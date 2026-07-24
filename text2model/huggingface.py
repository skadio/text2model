"""In-process Hugging Face models, loaded directly via unsloth (no daemon).

This is a distinct backend from Ollama: Ollama models are served by a local
daemon and reached over HTTP, same shape as the OpenAI backend. These models
are loaded straight into this process's memory instead.

Add a new model by adding an entry to HUGGINGFACE_MODELS below:
  - "harmony" prompt_style: the model expects a raw Harmony-formatted string
    and must NOT go through a chat template (e.g. gpt-oss finetunes).
  - "chat_template" prompt_style: the model uses a named unsloth chat
    template via `unsloth.chat_templates.get_chat_template` (e.g. Qwen).

Either way, the `prompt` handed in is the same fully-formed strategy prompt
(baseline/cot/agents/...) every other backend receives — this module only
wraps it in what the target format structurally requires, it does not
change prompt content.
"""
import datetime
import os
from typing import Any, Dict, Optional, Tuple

from text2model.utils import extract_code_blocks, print

HUGGINGFACE_MODELS: Dict[str, Dict[str, Any]] = {
    "learn2zinc-gpt-oss-20b": {
        "repo_id": "skadio/learn2zinc-GPT-oss-20B",
        "prompt_style": "harmony",
        "load_in_4bit": True,
    },
    "learn2zinc-qwen3-0.6b": {
        "repo_id": "skadio/learn2zinc-Qwen3-0.6B",
        "prompt_style": "chat_template",
        "chat_template": "qwen-2.5",
        "load_in_4bit": False,
    },
    "learn2zinc-llama-3.2-1b": {
        "repo_id": "skadio/learn2zinc-Llama-3.2-1B",
        "prompt_style": "chat_template",
        "chat_template": "llama-3.1",
        "load_in_4bit": False,
    },
    "learn2zinc-llama-3.2-3b": {
        "repo_id": "skadio/learn2zinc-Llama-3.2-3B",
        "prompt_style": "chat_template",
        "chat_template": "llama-3.1",
        "load_in_4bit": False,
    },
    "learn2zinc-gemma-2-9b": {
        "repo_id": "skadio/learn2zinc-Gemma-2-9B",
        "prompt_style": "chat_template",
        "chat_template": "gemma",
        "load_in_4bit": False,
    },
}

MAX_SEQ_LENGTH = 4096
MAX_NEW_TOKENS = 4096

# Loaded (model, tokenizer) pairs, keyed by alias — loaded at most once per
# process regardless of how many problems/strategy calls use them.
_LOADED_MODELS: Dict[str, Tuple[Any, Any]] = {}


def load_huggingface_model(model_alias: str) -> Tuple[Any, Any]:
    """Load (and cache) the (model, tokenizer) pair for a HUGGINGFACE_MODELS alias."""
    if model_alias in _LOADED_MODELS:
        return _LOADED_MODELS[model_alias]

    # Imported lazily: torch/unsloth are only needed by this backend, so
    # OpenAI-only / Ollama-only usage never pays for importing them.
    from unsloth import FastLanguageModel

    config = HUGGINGFACE_MODELS[model_alias]
    print(f"Loading Hugging Face model '{config['repo_id']}' (this happens once)...")

    model, tokenizer = FastLanguageModel.from_pretrained(
        model_name=config["repo_id"],
        max_seq_length=MAX_SEQ_LENGTH,
        dtype=None,
        load_in_4bit=config["load_in_4bit"],
    )
    FastLanguageModel.for_inference(model)

    if config["prompt_style"] == "chat_template":
        from unsloth.chat_templates import get_chat_template
        tokenizer = get_chat_template(tokenizer, chat_template=config["chat_template"])

    _LOADED_MODELS[model_alias] = (model, tokenizer)
    return model, tokenizer


def _build_harmony_prompt(prompt: str) -> str:
    today = datetime.date.today().isoformat()
    return (
        "<|start|>system<|message|>You are ChatGPT, a large language model trained by OpenAI.\n"
        "Knowledge cutoff: 2024-06\n"
        f"Current date: {today}\n\n"
        "Reasoning: medium\n\n"
        "# Valid channels: analysis, commentary, final. "
        "Channel must be included for every message.<|end|>"
        "<|start|>developer<|message|># Instructions\n\n"
        "Generate MiniZinc code for the following optimization problem.<|end|>"
        f"<|start|>user<|message|>{prompt}<|end|>"
        "<|start|>assistant"
    )


def _extract_harmony_final_channel(generated: str) -> str:
    if "<|channel|>final<|message|>" in generated:
        content = generated.split("<|channel|>final<|message|>")[-1]
        for stop in ["<|end|>", "<|return|>"]:
            content = content.split(stop)[0]
        return content.strip()

    for stop in ["<|end|>", "<|return|>"]:
        generated = generated.split(stop)[0]
    return generated.strip()


def _call_harmony(model, tokenizer, prompt: str) -> Optional[str]:
    import torch

    harmony_prompt = _build_harmony_prompt(prompt)
    inputs = tokenizer(harmony_prompt, return_tensors="pt").to(model.device)

    stop_token_ids = []
    for token in ["<|end|>", "<|return|>"]:
        encoded = tokenizer.encode(token, add_special_tokens=False)
        if encoded:
            stop_token_ids.append(encoded[0])

    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            max_new_tokens=MAX_NEW_TOKENS,
            do_sample=False,
            eos_token_id=stop_token_ids,
            pad_token_id=tokenizer.pad_token_id,
        )

    generated = tokenizer.decode(
        outputs[0][inputs["input_ids"].shape[1]:],
        skip_special_tokens=False,
    )
    response = _extract_harmony_final_channel(generated)
    return extract_code_blocks(response)


def _call_chat_template(model, tokenizer, prompt: str) -> Optional[str]:
    import torch

    messages = [{"role": "user", "content": prompt}]
    inputs = tokenizer.apply_chat_template(
        messages, add_generation_prompt=True, return_tensors="pt", return_dict=True,
    ).to(model.device)

    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            max_new_tokens=MAX_NEW_TOKENS,
            do_sample=False,
            pad_token_id=tokenizer.eos_token_id,
        )

    response = tokenizer.decode(
        outputs[0][inputs["input_ids"].shape[1]:], skip_special_tokens=True,
    )
    return extract_code_blocks(response)


def call_huggingface_api(client: Tuple[Any, Any], model_alias: str, prompt: str) -> Optional[str]:
    """Run a HUGGINGFACE_MODELS alias against `prompt`. `client` is the (model, tokenizer)
    pair returned by load_huggingface_model / main._init_client."""
    try:
        model, tokenizer = client
        prompt_style = HUGGINGFACE_MODELS[model_alias]["prompt_style"]

        if prompt_style == "harmony":
            return _call_harmony(model, tokenizer, prompt)
        else:
            return _call_chat_template(model, tokenizer, prompt)
    except Exception as e:
        print(f"Error calling Hugging Face model '{model_alias}': {e}")
        return None
