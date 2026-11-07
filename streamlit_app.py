
import streamlit as st
import pandas as pd
from pathlib import Path

# E-Commerce Data Analytics Dashboard
st.set_page_config(
    page_title="E-Commerce Analytics",
    page_icon="🛒",
    layout="wide"
)

st.title("🛒 E-Commerce Data Analytics Dashboard")
st.markdown("### End-to-End Business Intelligence Project")

# Find available CSV datasets
csv_files = list(Path("processed").glob("*.csv"))
csv_files += list(Path("dataset").glob("*.csv"))

if not csv_files:
    st.warning("No CSV files found in dataset or processed folders.")
    st.stop()

# Dataset selection
selected_file = st.sidebar.selectbox(
    "Select Dataset",
    csv_files,
    format_func=lambda x: x.name
)

# Load dataset
try:
    df = pd.read_csv(selected_file)
except UnicodeDecodeError:
    df = pd.read_csv(selected_file, encoding="latin1")

st.sidebar.success("Dataset loaded successfully")

# Dataset overview
st.header("1. Dataset Overview")

col1, col2, col3 = st.columns(3)

with col1:
    st.metric("Total Records", f"{len(df):,}")

with col2:
    st.metric("Total Columns", len(df.columns))

with col3:
    st.metric("Missing Values", f"{df.isna().sum().sum():,}")

# Data preview
st.header("2. Data Preview")
st.dataframe(df.head(100), use_container_width=True)

# Data types
st.header("3. Data Quality Analysis")

quality = pd.DataFrame({
    "Column": df.columns,
    "Data Type": df.dtypes.astype(str).values,
    "Missing Values": df.isna().sum().values,
    "Unique Values": df.nunique().values
})

st.dataframe(quality, use_container_width=True)

# Numerical analysis
st.header("4. Numerical Analysis")

numeric_columns = df.select_dtypes(include="number").columns.tolist()

if numeric_columns:
    selected_numeric = st.selectbox(
        "Select Numerical Column",
        numeric_columns
    )

    st.metric(
        f"Total {selected_numeric}",
        f"{df[selected_numeric].sum():,.2f}"
    )

    st.bar_chart(df[selected_numeric].head(30))
    st.write(df[numeric_columns].describe())
else:
    st.info("No numerical columns available.")

# Categorical analysis
st.header("5. Categorical Analysis")

categorical_columns = df.select_dtypes(
    include=["object", "category"]
).columns.tolist()

if categorical_columns:
    selected_category = st.selectbox(
        "Select Category",
        categorical_columns
    )

    category_counts = (
        df[selected_category]
        .value_counts()
        .head(10)
    )

    st.bar_chart(category_counts)
else:
    st.info("No categorical columns available.")

# Download processed dataset
st.header("6. Download Dataset")

st.download_button(
    label="Download CSV",
    data=df.to_csv(index=False).encode("utf-8"),
    file_name="ecommerce_analysis.csv",
    mime="text/csv"
)

st.success("E-Commerce Analytics Dashboard loaded!")
