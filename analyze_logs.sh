report_file="report.txt"
#Подсчитать общее количество запросов.
cnt=0
while read -r line; do
    cnt=$(( cnt + 1 ))
done < access.log
echo "общее число запросов $cnt" > "$report_file"

#Подсчитать количество уникальных IP-адресов. Строго с использованием awk.
ip_addresses=()
while read -r ip; do
    ip_addresses+=("$ip")
done < <(awk '{print $1}' ~/Desktop/logs/access.log | sort | uniq)
uniq_ips=0
for ip in "${ip_addresses[@]}"; do
    uniq_ips=$(( uniq_ips + 1 ))
done
echo "Количесвто уникальных IP $uniq_ips" >> "$report_file"

#Подсчитать количество запросов по методам (GET, POST и т.д.). Строго с использованием awk.
awk '
{
 split($0, fields, "\"");
 if (length(fields[2]) > 0) {
  split(fields[2], method_parts, " ");
  methods[method_parts[1]]++;
 }
}
END {
 for (method in methods) {
  printf "%s: %d\n", method, methods[method];
 }
}
' ~/Desktop/logs/access.log >> "$report_file"



