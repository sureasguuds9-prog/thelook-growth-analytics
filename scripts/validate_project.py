from pathlib import Path
import ast
import json

import nbformat
import sqlglot


project_root = Path(__file__).resolve().parents[1]
notebook_path = project_root / "notebooks" / "01_thelook_pandas_analysis.ipynb"
sql_dir = project_root / "sql"
outputs_dir = project_root / "outputs" / "pandas"

required_files = [
    project_root / "README.md",
    project_root / "LICENSE",
    notebook_path,
    sql_dir / "README.md",
    outputs_dir / "run_manifest.json",
]

for path in required_files:
    assert path.exists(), f"Missing required file: {path}"

notebook = nbformat.read(notebook_path, as_version=4)
nbformat.validate(notebook)

code_cells = [cell for cell in notebook.cells if cell.cell_type == "code"]
error_outputs = [
    output
    for cell in code_cells
    for output in cell.get("outputs", [])
    if output.get("output_type") == "error"
]

for number, cell in enumerate(code_cells, start=1):
    ast.parse(cell.source, filename=f"notebook_cell_{number}")

assert not error_outputs, "Notebook contains saved execution errors"
assert all(cell.get("execution_count") is not None for cell in code_cells), "Notebook has unexecuted code cells"

sql_files = sorted(sql_dir.glob("*.sql"))
assert len(sql_files) == 10, "Expected 10 SQL files"

for path in sql_files:
    sqlglot.parse(path.read_text(encoding="utf-8"), read="bigquery")

manifest = json.loads((outputs_dir / "run_manifest.json").read_text(encoding="utf-8"))
assert manifest["order_mart_rows"] == manifest["order_mart_unique_orders"]
assert manifest["data_quality_issue_count"] == 0
assert len(list((outputs_dir / "tables").glob("*.csv"))) == 13
assert len(list((outputs_dir / "figures").glob("*.png"))) == 9

print("Project validation passed")
print(f"Notebook: {len(code_cells)} executed code cells, 0 saved errors")
print(f"SQL: {len(sql_files)} BigQuery files")
print("Artifacts: 13 tables and 9 figures")
