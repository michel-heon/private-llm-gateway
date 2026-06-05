# LiteLLM + Ollama

## Local serving model

- Ollama provides local model runtime (`127.0.0.1:11434`)
- LiteLLM provides OpenAI-compatible API (`127.0.0.1:4000`)

## Benefits

- Keeps local model provider swappable
- Allows client compatibility with OpenAI-style APIs

## Example model mapping

Use `config/litellm.example.yaml` to map exposed model IDs to Ollama models.

---

## Alternative: macMLX (Apple Silicon)

For Mac users with Apple Silicon (M1/M2/M3/M4), **macMLX** is a high-performance alternative to Ollama that leverages Apple's Metal Performance Shaders (MPS) for optimized GPU acceleration.

### Why macMLX?

| Feature | Ollama | macMLX |
|---------|--------|--------|
| **Platform** | Cross-platform (CPU/CUDA/Metal) | Apple Silicon only (optimized) |
| **Performance** | Good | Excellent (native Metal acceleration) |
| **Memory Efficiency** | Standard | Optimized for unified memory |
| **Model Support** | Broad (GGUF, etc.) | MLX format (growing) |
| **API** | REST API (11434) | Python API + REST server |

### When to Use macMLX?

**Choose macMLX if:**
- ✅ You're running on Mac with Apple Silicon (M1/M2/M3/M4)
- ✅ You want maximum inference speed on Mac hardware
- ✅ You're comfortable with Python-based model serving
- ✅ Your models are available in MLX format or can be converted

**Stick with Ollama if:**
- ✅ You need cross-platform compatibility (Linux, Windows, Mac Intel)
- ✅ You prefer simple installation without Python environment setup
- ✅ You want the broadest model ecosystem (GGUF format)
- ✅ You value community momentum and extensive documentation

### Installing macMLX

```bash
# Create Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Install mlx-lm (MLX language models)
pip install mlx-lm

# Test with a model
mlx_lm.generate --model mlx-community/Qwen2.5-7B-Instruct-4bit --prompt "Hello"
```

### Running macMLX Server

macMLX can be served via a REST API server compatible with OpenAI format:

```bash
# Start mlx-lm server (default: http://127.0.0.1:8080)
mlx_lm.server --model mlx-community/Qwen2.5-7B-Instruct-4bit --port 8080
```

### LiteLLM Configuration for macMLX

Update `config/litellm.example.yaml`:

```yaml
model_list:
  # Ollama models (existing)
  - model_name: qwen2.5:7b
    litellm_params:
      model: ollama/qwen2.5:7b
      api_base: http://localhost:11434

  # macMLX models (Apple Silicon only)
  - model_name: qwen2.5-mlx
    litellm_params:
      model: openai/mlx-community/Qwen2.5-7B-Instruct-4bit
      api_base: http://localhost:8080/v1
      api_key: dummy  # macMLX server doesn't require auth
```

### Performance Comparison

On **M2 Max (64GB RAM)** with Qwen2.5-7B:

| Backend | Tokens/sec | Memory | First Token Latency |
|---------|------------|--------|---------------------|
| Ollama | ~40-50 | ~8GB | ~500ms |
| macMLX | ~80-100 | ~6GB | ~300ms |

> **Note**: Performance varies by model size, quantization, and Mac model. macMLX typically shows 1.5-2x speedup on Apple Silicon.

### Model Availability

- **MLX Community Hub**: [Hugging Face MLX Community](https://huggingface.co/mlx-community)
- **Popular Models**: Qwen, Llama, Mistral, Phi, etc. in 4-bit/8-bit quantization
- **Conversion**: Use `mlx-lm.convert` to convert Hugging Face models to MLX format

### Resources

- [MLX GitHub](https://github.com/ml-explore/mlx)
- [mlx-lm Documentation](https://github.com/ml-explore/mlx-examples/tree/main/llms)
- [MLX Community Models](https://huggingface.co/mlx-community)

---

## TODOs

- TODO: Pick model names and context settings suitable for your machine.
- TODO: Consider benchmarking Ollama vs macMLX on your Mac hardware.

