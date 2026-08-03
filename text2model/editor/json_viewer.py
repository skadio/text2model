import flet as ft


def create_json_viewer(json_data: dict) -> ft.Column:
    """Create a formatted view of JSON data"""
    if not isinstance(json_data, dict):
        return ft.Column([ft.Text("Invalid JSON data", color=ft.colors.RED, size=14)])

    sections = []

    if 'metadata' in json_data:
        metadata = json_data['metadata']
        metadata_items = [
            ft.Row([
                ft.Icon(ft.icons.LABEL, size=18, color=ft.colors.BLUE),
                ft.Text("Name:", weight=ft.FontWeight.BOLD, size=14),
                ft.Text(str(metadata.get('name', 'N/A')), size=14),
            ], spacing=8),
            ft.Row([
                ft.Icon(ft.icons.DOMAIN, size=18, color=ft.colors.BLUE),
                ft.Text("Domain:", weight=ft.FontWeight.BOLD, size=14),
                ft.Text(str(metadata.get('domain', 'N/A')), size=14),
            ], spacing=8),
            ft.Row([
                ft.Icon(ft.icons.FLAG, size=18, color=ft.colors.BLUE),
                ft.Text("Objective:", weight=ft.FontWeight.BOLD, size=14),
                ft.Text(str(metadata.get('objective', 'N/A')), size=14),
            ], spacing=8),
        ]

        if 'source' in metadata:
            metadata_items.append(
                ft.Row([
                    ft.Icon(ft.icons.SOURCE, size=18, color=ft.colors.BLUE),
                    ft.Text("Source:", weight=ft.FontWeight.BOLD, size=14),
                    ft.Text(str(metadata.get('source', 'N/A')), size=14),
                ], spacing=8))

        if 'identifier' in metadata:
            metadata_items.append(
                ft.Row([
                    ft.Icon(ft.icons.TAG, size=18, color=ft.colors.BLUE),
                    ft.Text("Identifier:", weight=ft.FontWeight.BOLD, size=14),
                    ft.Text(str(metadata.get('identifier', 'N/A')), size=14),
                ], spacing=8))

        if 'constraints' in metadata and isinstance(metadata['constraints'], list):
            constraints_text = ", ".join(metadata['constraints'])
            metadata_items.append(
                ft.Row([
                    ft.Icon(ft.icons.RULE, size=18, color=ft.colors.BLUE),
                    ft.Text("Constraints:", weight=ft.FontWeight.BOLD, size=14),
                    ft.Text(constraints_text, size=14),
                ], spacing=8))

        sections.append(
            ft.Container(
                content=ft.Column([
                    ft.Text("Metadata", size=16, weight=ft.FontWeight.BOLD, color=ft.colors.BLUE_900),
                    ft.Divider(height=1, color=ft.colors.BLUE_200),
                    ft.Column(metadata_items, spacing=8),
                ], spacing=8),
                padding=12,
                bgcolor=ft.colors.BLUE_50,
                border_radius=8,
                border=ft.border.all(2, ft.colors.BLUE_200),
            ))

    if 'description' in json_data:
        sections.append(
            ft.Container(
                content=ft.Column([
                    ft.Text("Problem Description", size=16, weight=ft.FontWeight.BOLD, color=ft.colors.GREEN_900),
                    ft.Divider(height=1, color=ft.colors.GREEN_200),
                    ft.Text(str(json_data['description']), size=13),
                ], spacing=8),
                padding=12,
                bgcolor=ft.colors.GREEN_50,
                border_radius=8,
                border=ft.border.all(2, ft.colors.GREEN_200),
            ))

    if 'parameters' in json_data and isinstance(json_data['parameters'], list):
        param_widgets = []
        for i, param in enumerate(json_data['parameters'], 1):
            shape_str = str(param.get('shape', [])) if param.get('shape') else "scalar"
            param_widgets.append(
                ft.Container(
                    content=ft.Column([
                        ft.Row([
                            ft.Text(f"{i}.", size=13, color=ft.colors.GREY_600),
                            ft.Text(f"{param.get('symbol', 'unknown')}", weight=ft.FontWeight.BOLD,
                                    size=14, color=ft.colors.INDIGO_900),
                            ft.Text(f"(shape: {shape_str})", size=12, color=ft.colors.GREY_600, italic=True),
                        ], spacing=6),
                        ft.Text(f"{param.get('definition', '')}", size=13, color=ft.colors.GREY_800),
                    ], spacing=4),
                    padding=8,
                    bgcolor=ft.colors.WHITE,
                    border_radius=5,
                    border=ft.border.all(1, ft.colors.GREY_300),
                ))

        sections.append(
            ft.Container(
                content=ft.Column([
                    ft.Text(f"Input Parameters ({len(json_data['parameters'])})", size=16,
                            weight=ft.FontWeight.BOLD, color=ft.colors.INDIGO_900),
                    ft.Divider(height=1, color=ft.colors.INDIGO_200),
                    ft.Column(param_widgets, spacing=8),
                ], spacing=8),
                padding=12,
                bgcolor=ft.colors.INDIGO_50,
                border_radius=8,
                border=ft.border.all(2, ft.colors.INDIGO_200),
            ))

    if 'output' in json_data and isinstance(json_data['output'], list):
        output_widgets = []
        for i, output in enumerate(json_data['output'], 1):
            shape_str = str(output.get('shape', [])) if output.get('shape') else "scalar"
            output_widgets.append(
                ft.Container(
                    content=ft.Column([
                        ft.Row([
                            ft.Text(f"{i}.", size=13, color=ft.colors.GREY_600),
                            ft.Text(f"{output.get('symbol', 'unknown')}", weight=ft.FontWeight.BOLD,
                                    size=14, color=ft.colors.ORANGE_900),
                            ft.Text(f"(shape: {shape_str})", size=12, color=ft.colors.GREY_600, italic=True),
                        ], spacing=6),
                        ft.Text(f"{output.get('definition', '')}", size=13, color=ft.colors.GREY_800),
                    ], spacing=4),
                    padding=8,
                    bgcolor=ft.colors.WHITE,
                    border_radius=5,
                    border=ft.border.all(1, ft.colors.GREY_300),
                ))

        sections.append(
            ft.Container(
                content=ft.Column([
                    ft.Text(f"Output Variables ({len(json_data['output'])})", size=16,
                            weight=ft.FontWeight.BOLD, color=ft.colors.ORANGE_900),
                    ft.Divider(height=1, color=ft.colors.ORANGE_200),
                    ft.Column(output_widgets, spacing=8),
                ], spacing=8),
                padding=12,
                bgcolor=ft.colors.ORANGE_50,
                border_radius=8,
                border=ft.border.all(2, ft.colors.ORANGE_200),
            ))

    return ft.Column(sections, spacing=12, scroll=ft.ScrollMode.AUTO)
