# 🤖 Multilingual Medical Chatbot

A **FastAPI** server that uses FAISS-based RAG (Retrieval-Augmented Generation) with Flan-T5 to answer medical questions from a pre-built knowledge base.

---

## 🖥️ Setup (First Time Only — macOS Apple Silicon)

### 1. Prerequisites
Make sure Python 3.10 is installed:
```bash
python3.10 --version
```
If not: `brew install python@3.10`

---

### 2. Create Virtual Environment
```bash
cd ~/Desktop/multilingual-chatbot
python3.10 -m venv venv
```

---

### 3. Activate the Virtual Environment
```bash
source venv/bin/activate
```
> You should see `(venv)` at the start of your terminal prompt.

---

### 4. Install Dependencies
```bash
# Step 1: Install PyTorch for Apple Silicon first
pip install torch torchvision torchaudio

# Step 2: Install everything else
pip install fastapi "uvicorn[standard]" sentence-transformers faiss-cpu \
    transformers datasets soundfile langchain langchain-text-splitters \
    python-multipart
```

---

### 5. Copy the FAISS Index
```bash
cp ~/Desktop/multilingual-chatbot/faiss.index /tmp/faiss.index
```
> ⚠️ You need to redo this step if you restart your Mac (since `/tmp` is cleared on reboot).

---

## 🚀 Running the Server (Every Time)

```bash
cd ~/Desktop/multilingual-chatbot
source venv/bin/activate
cp faiss.index /tmp/faiss.index
uvicorn app:app --host 0.0.0.0 --port 8000
```

Wait for:
```
INFO:     Application startup complete.
```
> ⏳ First startup takes ~1 min (downloads models). Subsequent starts are fast (models cached in `/tmp/hf_cache`).

---

## ✅ Verify It's Running

```bash
curl http://localhost:8000/health
```
Expected response:
```json
{"ok": true, "index_chunks": 7301}
```

Or open **http://localhost:8000/docs** in your browser (interactive Swagger UI).

---

## 📡 API Endpoints

### Chat
```bash
curl -X POST http://localhost:8000/chat \
  -F "user_id=user1" \
  -F "user_input=What are the symptoms of diabetes?"
```

**Optional parameters:**
| Field | Default | Description |
|-------|---------|-------------|
| `user_id` | *(required)* | Unique ID to track conversation memory |
| `user_input` | *(required)* | Your question |
| `target_language` | `null` | Translate response (e.g. `Hindi`, `French`) |
| `top_k` | `3` | Number of FAISS chunks to retrieve |
| `retrieval_threshold` | `0.30` | Minimum similarity score to use a chunk |

**Example response:**
```json
{
  "user_id": "user1",
  "input": "What are the symptoms of diabetes?",
  "matched_ids": ["diabetes_0", "medical_TOTAL_6382"],
  "scores": [0.697, 0.670],
  "used_retrieval": true,
  "response": "Type 2 diabetes symptoms include excessive thirst and frequent urination."
}
```

---

### View Conversation Memory
```bash
curl http://localhost:8000/memory/user1
```

### Clear Conversation Memory
```bash
curl -X POST http://localhost:8000/memory/clear -F "user_id=user1"
```

### Add a New Document to the Index
```bash
curl -X POST http://localhost:8000/ingest \
  -H "Content-Type: application/json" \
  -d '{"id": "doc1", "text": "Your document text here...", "source": "manual"}'
```

---

## 🗂️ Project Structure

```
multilingual-chatbot/
├── app.py              # Main FastAPI application
├── requirements.txt    # Python dependencies
├── faiss.index         # Pre-built FAISS vector index (copy to /tmp on start)
├── docs_meta.json      # Metadata for all indexed document chunks
├── Dockerfile          # For containerised deployment
├── render.yaml         # Render.com deployment config
└── README.md           # This file
```

---

## 🐛 Troubleshooting

| Problem | Fix |
|---------|-----|
| `curl: (52) Empty reply from server` | Don't use `--reload` flag. Run: `uvicorn app:app --host 0.0.0.0 --port 8000` |
| `ModuleNotFoundError: langchain.text_splitter` | Already fixed in `app.py` — import now uses `langchain_text_splitters` |
| `Unknown task text2text-generation` | Already fixed in `app.py` — uses direct `model.generate()` instead of pipeline |
| Server slow on first start | Normal — downloading ~1GB of models. Cached after first run |
| `/tmp/faiss.index` not found | Run `cp faiss.index /tmp/faiss.index` from the project directory |
| `Segmentation fault` with torch+faiss | Already fixed — `KMP_DUPLICATE_LIB_OK=TRUE` and `OMP_NUM_THREADS=1` set in `app.py` |

---

## 📝 Notes

- The chatbot uses **Flan-T5-base** as the LLM and **all-MiniLM-L6-v2** for embeddings.
- It is a **medical assistant** that only answers based on retrieved context — it will respond with *"I do not know, please consult a medical professional."* when no relevant context is found.
- Models are cached to `/tmp/hf_cache` — this is cleared on reboot, so the first startup after a Mac restart will re-download (~1GB).
