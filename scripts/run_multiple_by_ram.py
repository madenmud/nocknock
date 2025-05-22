import psutil
import subprocess
import os
import shutil
import time
import uuid

def get_total_memory_gb():
    """Get total system memory in GB."""
    return psutil.virtual_memory().total / (1024 ** 3)

def calculate_container_count():
    """Calculate number of containers based on 1 per 32GB of memory."""
    total_memory = get_total_memory_gb()
    return max(1, int(total_memory // 32))

def create_container_dirs(base_dir, container_id):
    """Create directories for a container's data, wallet, and scripts."""
    dirs = {
        'data': os.path.join(base_dir, f"data_{container_id}"),
        'wallet': os.path.join(base_dir, f"wallet-data_{container_id}"),
        'scripts': os.path.join(base_dir, f"scripts_{container_id}")
    }
    for dir_path in dirs.values():
        os.makedirs(dir_path, exist_ok=True)
    return dirs

def copy_env_file(base_dir, container_id):
    """Copy .env file to container-specific location."""
    src_env = os.path.join(base_dir, ".env")
    dst_env = os.path.join(base_dir, f".env_{container_id}")
    if os.path.exists(src_env):
        shutil.copy(src_env, dst_env)
    return dst_env

def start_containers(num_containers, base_dir):
    """Start the specified number of Docker containers."""
    container_names = []
    for i in range(num_containers):
        container_id = str(uuid.uuid4())[:8]
        container_name = f"nockchain_{container_id}"
        dirs = create_container_dirs(base_dir, container_id)
        env_file = copy_env_file(base_dir, container_id)
        
        cmd = [
            "docker", "run", "-d", "--rm",
            "-v", f"{dirs['data']}:/nockchain/data",
            "-v", f"{dirs['wallet']}:/nockchain/data/wallet",
            "-v", f"{dirs['scripts']}:/nockchain/scripts",
            "-v", f"{env_file}:/nockchain/.env",
            "--name", container_name,
            "--net=ipvlan",
            "madenmud/nockchain-node:latest",
            "make", "run-nockchain"
        ]
        
        try:
            subprocess.run(cmd, check=True)
            print(f"Started container: {container_name}")
            container_names.append(container_name)
        except subprocess.CalledProcessError as e:
            print(f"Failed to start container {container_name}: {e}")
    
    return container_names

def stop_containers(container_names):
    """Stop all specified Docker containers."""
    for container_name in container_names:
        try:
            subprocess.run(["docker", "stop", container_name], check=True)
            print(f"Stopped container: {container_name}")
        except subprocess.CalledProcessError as e:
            print(f"Failed to stop container {container_name}: {e}")

def main():
    base_dir = os.getcwd()
    num_containers = calculate_container_count()
    print(f"System memory: {get_total_memory_gb():.2f} GB")
    print(f"Starting {num_containers} container(s) (1 per 32GB)...")
    
    # Start containers
    container_names = start_containers(num_containers, base_dir)
    
    print("\nContainers are running. Press Ctrl+C to stop them.")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nStopping containers...")
        stop_containers(container_names)
        print("All containers stopped.")

if __name__ == "__main__":
    main()

