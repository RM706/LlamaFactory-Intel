# LlamaFactory-Intel

Intel GPU 环境下的Llama Factory，支持xpu

---

特点：
1. 基于[Intel/PyTorch](https://hub.docker.com/r/intel/pytorch)与[LlamaFactory](https://github.com/hiyouga/LlamaFactory)构建，适用于Intel GPU
2. ...

---

使用方法：

1. 下载 `entrypoint.sh` `llama-factory.dockerfile` `llama-factory.compose`
2. 构建镜像（或者使用已经构建好的[biiibiii/llamafactory-intel](https://hub.docker.com/r/biiibiii/llamafactory-intel)）

```
docker build \
    -f "llama-factory.dockerfile" \
    -t "biiibiii/llamafactory-intel:latest" \
    .
```

3. 启动容器 `docker compose -f llama-factory.compose up -d`
4. 打开浏览器，访问:`http://localhost:7860`
