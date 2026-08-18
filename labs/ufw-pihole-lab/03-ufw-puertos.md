# Fase 3 — UFW: abrir, cerrar y borrar puertos

El **firewall** es el "portero" de cada VM: decide qué puertos se ven desde fuera.
UFW es la capa amigable sobre iptables/nftables.

> ⚠️ **Regla de oro**: abrir el puerto de SSH (22/tcp) **ANTES** de `ufw enable`,
> o te quedas fuera de la VM.

## Diagrama de concepto

```
                        ┌────────────────── VM ──────────────────┐
   desde fuera          │                                       │
   (host u otras VMs)   │        UFW (el portero)               │
                        │                                       │
   ──► 22/tcp  ────────►│  ✅ ALLOW  ──►  sshd (:22)           │
   ──► 80/tcp  ────────►│  ✅ ALLOW  ──►  nginx (:80)          │
   ──► 8080   ─────────►│  ❌ DENY   ──►  (nadie escucha)      │
   ──► 53/tcp  ────────►│  ❌ DENY   ──►  (Pi-hole, más tarde) │
                        └───────────────────────────────────────┘
```

## 1. Instalar lo necesario (dentro de cada VM)

```bash
sudo apt update && sudo apt install -y ufw nginx openssh-server
sudo ufw status                 # → Status: inactive
```

## 2. Abrir puertos y habilitar (siempre SSH primero)

```bash
sudo ufw allow 22/tcp           # SSH
sudo ufw allow 80/tcp           # nginx (HTTP)
sudo ufw enable                 # se activa YA: bloquea todo lo demás
sudo ufw status numbered
```

Resultado en vm-pihole (estado real del lab):

```
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere
[ 2] 80/tcp                     ALLOW IN    Anywhere
[ 3] 22/tcp (v6)                ALLOW IN    Anywhere (v6)
[ 4] 80/tcp (v6)                ALLOW IN    Anywhere (v6)
```

## 3. Verificar desde el HOST (nexuscloud)

```bash
curl -I http://192.168.122.219          # → HTTP/1.1 200  (puerto 80 abierto)
nc -zv 192.168.122.219 80               # → open
nc -zv 192.168.122.219 8080             # → blocked (UFW no lo permite)
```

> El `netcat` se instala con `sudo apt install -y netcat-openbsd` si falta.
> **Las pruebas se hacen en nexuscloud**, no en tu máquina local (tu local no tiene
> ruta a `192.168.122.0/24`).

## 4. Ver el corte en vivo (deny / delete)

```bash
# DENTRO de la VM
sudo ufw deny 80/tcp            # cierra el puerto 80

# DESDE nexuscloud
curl -I http://192.168.122.219          # → ahora falla (corte visible)

# DENTRO de la VM: restaurar
sudo ufw delete 2               # borra la regla 80/tcp por número
sudo ufw allow 80/tcp           # o la vuelves a abrir
```

## 5. Puerto custom de SSH (re-mapeo)

```bash
# DENTRO de la VM
sudo nano /etc/ssh/sshd_config          # cambiar Port 22 → Port 2222
sudo systemctl restart ssh
sudo ufw allow 2222/tcp

# DESDE nexuscloud
ssh -p 2222 <usuario>@<ip>              # ✅ entra por el puerto nuevo
ssh <usuario>@<ip>                      # ❌ este ahora falla
```

## 6. Reto entre VMs (bloqueo cruzado)

Desde `vm-client-1`, probar los puertos de `vm-pihole`:

```bash
nc -zv 192.168.122.219 22       # open (SSH permitido)
nc -zv 192.168.122.219 8080     # blocked (no hay regla → UFW lo tapa)
```

## Comandos útiles de UFW

| Comando | Qué hace |
|---|---|
| `sudo ufw status numbered` | Ver reglas con número |
| `sudo ufw allow 22/tcp` | Abrir TCP 22 |
| `sudo ufw deny 80/tcp` | Cerrar TCP 80 |
| `sudo ufw delete 2` | Borrar la regla 2 |
| `sudo ufw enable` / `disable` | Activar / desactivar el firewall |
| `sudo ufw app list` | Perfiles de aplicación conocidos |
| `sudo ufw reset` | Borrar todas las reglas |
