LATEST_PID=$(ps -eo pid,lstart --no-header | sort -k2,3 -k4,5 | tail -n1 | awk '{print $1}')

echo "PID последнего запущенного процесса: $LATEST_PID"

