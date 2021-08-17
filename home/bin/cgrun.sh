#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <bin>" >&2
    exit 1
fi

CGTREE=/sys/fs/cgroup/cpu

sudo -s <<EOF
[ ! -d ${CGTREE}/cpulimit ] && mkdir ${CGTREE}/cpulimit
echo 1000000 > ${CGTREE}/cpulimit/cpu.cfs_period_us
echo 100000 > ${CGTREE}/cpulimit/cpu.cfs_quota_us
EOF

# Sub-shell in background
(
  # Pid of the current sub-shell
  # ($$ would return the pid of the father process)
  MY_PID=$BASHPID

  # Move current process into the cgroup
  sudo sh -c "echo ${MY_PID} > ${CGTREE}/cpulimit/tasks"

  # Run the command with calling user id (it inherits the cgroup)
  exec "$@"

) &

# Wait for the sub-shell
wait $!

# Exit code of the sub-shell
rc=$?

# Delete the cgroup
sudo rmdir ${CGTREE}/cpulimit

# Exit with the return code of the sub-shell
exit $rc
