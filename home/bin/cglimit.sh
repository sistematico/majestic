#!/usr/bin/env bash

# Cria o grupo
sudo cgcreate -g cpu:/cpulimit

# Periodo 1s
sudo cgset -r cpu.cfs_period_us=1000000 cpulimit

# Cota 0.5s (%50)
sudo cgset -r cpu.cfs_quota_us=500000 cpulimit

# Checa os limites
# sudo cgget -g cpu:cpulimit

# Executa o comando
sudo cgexec -g cpu:cpulimit $@