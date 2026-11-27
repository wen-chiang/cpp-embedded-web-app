# Multi-stage build for C++ Embedded Web App
# Stage 1: Builder - Compile the application
FROM ubuntu:24.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Conan via pip
RUN pip3 install --no-cache-dir conan==2.34.0

# Set working directory
WORKDIR /build

# Copy project files
COPY CMakeLists.txt .
COPY conanfile.txt .
COPY src/ src/
COPY tests/ tests/

# Install Conan dependencies
RUN conan profile detect --force && \
    conan install . --output-folder=build --build=missing

# Configure CMake
RUN cmake -S . -B build \
    -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release

# Build the application
RUN cmake --build build --config Release

# Stage 2: Runtime - Run the application
FROM ubuntu:24.04

# Install runtime dependencies (minimal)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libstdc++6 \
    libgcc-s1 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy only the compiled executable from builder
COPY --from=builder /build/build/cpp_embedded_web /app/

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Run the application
CMD ["./cpp_embedded_web"]
