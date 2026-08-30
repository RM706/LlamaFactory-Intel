FROM intel/pytorch:xpu-2.11.0-ubuntu24.04-20260608

	# 使用 ustc 源
	RUN rm -rf /etc/apt/sources.list.d/* && \
	    printf '%s\n' \
	    "deb https://mirrors.ustc.edu.cn/ubuntu/ noble main restricted universe multiverse" \
	    "deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble main restricted universe multiverse" \
	    "deb https://mirrors.ustc.edu.cn/ubuntu/ noble-updates main restricted universe multiverse" \
	    "deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble-updates main restricted universe multiverse" \
	    "deb https://mirrors.ustc.edu.cn/ubuntu/ noble-backports main restricted universe multiverse" \
	    "deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble-backports main restricted universe multiverse" \
	    "deb https://mirrors.ustc.edu.cn/ubuntu/ noble-security main restricted universe multiverse" \
	    "deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble-security main restricted universe multiverse" \
	    "deb https://mirrors.ustc.edu.cn/ubuntu/ noble-proposed main restricted universe multiverse" \
	    "deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble-proposed main restricted universe multiverse" \
	    > /etc/apt/sources.list

	# 添加 Intel oneAPI 仓库
	RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null && \
	    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list

	# 更新
	RUN apt-get update && \
	    apt-get install -y --no-install-recommends git intel-oneapi-compiler-dpcpp-cpp intel-oneapi-mkl-devel && \
	    apt-get clean && \
	    rm -rf /var/lib/apt/lists/*

	# 设置镜像源
	RUN python -m pip install --upgrade pip -i https://mirrors.ustc.edu.cn/pypi/simple && \
	    pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

	# 创建工作目录，pull LlamaFactory
	WORKDIR /opt/LlamaFactory
	RUN git clone https://github.com/hiyouga/LlamaFactory.git /opt/LlamaFactory && \
		cd /opt/LlamaFactory \
	    pip install --no-cache-dir -e . && \
	    pip install --no-cache-dir -r requirements/metrics.txt -r requirements/deepspeed.txt

	# 安装 pip 包
	RUN pip install --no-cache-dir swanlab -i https://mirrors.aliyun.com/pypi/simple/

	# 创建默认备份目录，供空挂载时恢复
	RUN mkdir -p /opt/LlamaFactory-defaults && \
		cp -a /opt/LlamaFactory/. /opt/LlamaFactory-defaults/

	# 设置时区为 Asia/Shanghai
	RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
		echo "Asia/Shanghai" > /etc/timezone

	COPY entrypoint.sh /usr/local/bin/entrypoint.sh
	RUN chmod +x /usr/local/bin/entrypoint.sh

	ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["llamafactory-cli", "webui"]
EOF
