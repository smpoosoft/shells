import requests
import threading
import time
import sys

def get_public_ip(stop_event):
    try:
        response = requests.get('http://ip.42.pl/raw')
        response.raise_for_status()  # 如果响应状态码不是 200，将引发 HTTPError 异常
    except requests.RequestException as e:
        print(str(e))
        stop_event.set()
        return

    ip = response.text
    if not ip.count('.') == 3:  # 检查 IP 地址是否有效
        print("Invalid IP address: {}".format(ip))
    else:
        print(ip)

    stop_event.set()  # 停止动画

def display_spinner(stop_event):
    spinner = '|/-\\'
    i = 0
    while not stop_event.is_set():  # 当 stop_event 被设置时，停止动画
        sys.stderr.write(spinner[i] + '\r')
        sys.stderr.flush()
        time.sleep(0.1)
        i = (i + 1) % len(spinner)
    sys.stderr.write(' \r')  # 清除最后的动画字符

def main():
    stop_event = threading.Event()
    ip_thread = threading.Thread(target=get_public_ip, args=(stop_event,))
    spinner_thread = threading.Thread(target=display_spinner, args=(stop_event,))

    ip_thread.start()
    spinner_thread.start()

    while ip_thread.is_alive():  # 等待 IP 地址查询线程结束
        time.sleep(0.1)

    spinner_thread.join()  # 确保动画已经停止

if __name__ == "__main__":
    main()
