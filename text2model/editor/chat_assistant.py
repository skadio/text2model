from typing import Any, Dict

import openai

# Default model for the in-editor AI chat assistant.
DEFAULT_CHAT_MODEL = "gpt-5.2"


class ChatAssistant:
    """AI Chat Assistant using OpenAI API"""

    def __init__(self, api_key: str = "", model: str = DEFAULT_CHAT_MODEL):
        self.api_key = api_key
        self.model = model
        self.client = None
        self.conversation_history = []
        self.current_context = {}
        if api_key:
            self.client = openai.OpenAI(api_key=api_key)

    def set_api_key(self, api_key: str):
        """Set OpenAI API key"""
        self.api_key = api_key
        self.client = openai.OpenAI(api_key=api_key)

    def set_model(self, model: str):
        """Set the OpenAI model used for chat responses"""
        self.model = model

    def update_context(self, context: Dict[str, Any]):
        """Update the current context for AI assistance"""
        self.current_context = context

    def send_message(self, user_message: str) -> str:
        """Send a message to the AI and get a response"""
        if not self.client:
            return "Error: OpenAI API key not set. Please set it in the settings."

        try:
            system_message = self._build_system_message()

            self.conversation_history.append({"role": "user", "content": user_message})

            # Keep only last 6 messages (6 turns = 3 user + 3 assistant)
            if len(self.conversation_history) > 6:
                self.conversation_history = self.conversation_history[-6:]

            messages = [{"role": "system", "content": system_message}] + self.conversation_history

            # gpt-4o / gpt-5.2 / gpt-5.5 / gpt-5.6 are reasoning models, so skip
            # temperature/max_tokens (same pattern as call_openai_api in utils.py)
            completion = self.client.chat.completions.create(model=self.model, messages=messages)

            assistant_message = completion.choices[0].message.content.strip()
            self.conversation_history.append({"role": "assistant", "content": assistant_message})

            return assistant_message

        except Exception as e:
            return f"Error communicating with OpenAI: {str(e)}"

    def _build_system_message(self) -> str:
        """Build a context-aware system message"""
        base_msg = """You are an expert assistant helping modeling and solving combinatorial problems using MiniZinc models.
You can help with:
- Rephrasing problem descriptions
- Generating or improving MiniZinc code
- Creating appropriate data files (.dzn format)
- Analyzing constraints and optimization objectives
- Debugging MiniZinc models"""

        if self.current_context:
            base_msg += "\n\nCurrent problem context:\n"

            if 'input_json' in self.current_context:
                input_data = self.current_context['input_json']
                if isinstance(input_data, dict):
                    if 'description' in input_data:
                        base_msg += f"\nProblem Description: {input_data['description']}\n"
                    if 'metadata' in input_data:
                        meta = input_data['metadata']
                        base_msg += f"Problem Name: {meta.get('name', 'N/A')}\n"
                        base_msg += f"Domain: {meta.get('domain', 'N/A')}\n"
                        base_msg += f"Objective: {meta.get('objective', 'N/A')}\n"

            if self.current_context.get('data_dzn'):
                base_msg += f"\nCurrent data.dzn:\n{self.current_context['data_dzn'][:300]}...\n"

            if self.current_context.get('model_mzn'):
                base_msg += f"\nCurrent model.mzn:\n{self.current_context['model_mzn'][:500]}...\n"

        return base_msg

    def clear_history(self):
        """Clear conversation history"""
        self.conversation_history = []
