alias plz='sudo'
alias version='lsb_release -a'






ucgroups() {
  stat -fc %T /sys/fs/cgroup/
  echo ""
  (sudo mount | grep cgroup) 2>/dev/null
  echo ""
  (sudo docker info | grep Cgroup) 2>/dev/null
}
