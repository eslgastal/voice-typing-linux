FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    ffmpeg \
    gcc \
    gir1.2-gtk-4.0 \
    gir1.2-ibus-1.0 \
    ibus \
    libasound2 \
    libasound2-dev \
    libcairo2-dev \
    libgirepository1.0-dev \
    libglib2.0-0 \
    libglib2.0-dev \
    libx11-6 \
    libxext6 \
    libxinerama1 \
    libxtst6 \
    linux-libc-dev \
    netcat-openbsd \
    pkg-config \
    portaudio19-dev \
    procps \
    python3 \
    python3-cairo \
    python3-dev \
    python3-gi \
    python3-gi-cairo \
    python3-pip \
    python3-tk \
    scrot \
    sox \
    wl-clipboard \
    wmctrl \
    xbindkeys \
    xdotool \
    ydotool \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

RUN grep -vE '^(torch|PyGObject|pycairo)\b' /tmp/requirements.txt > /tmp/requirements-container.txt \
 && python3 -m pip install --index-url https://download.pytorch.org/whl/cu124 torch \
 && python3 -m pip install -r /tmp/requirements-container.txt

COPY . /app

RUN chmod +x /app/voice /app/voice-toggle /app/enhanced-voice-typing.py /app/ibus-engine-voice-typing

ENTRYPOINT ["python3", "/app/enhanced-voice-typing.py"]
CMD ["--streaming", "--model", "large-v3-turbo", "--device", "cuda"]
