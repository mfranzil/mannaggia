#!/bin/sh
############################################################
# Mannaggiatore automatico per VUA depressi
# idea originale by Alexiobash dallo script incazzatore.sh
# ampliata, riscritta e mantenuta da Pietro "Legolas" Suffritti
# convertita in mannaggia.sh rel 0.2
# Collaborators:
# Enrico "Henryx" Bianchi, Alessandro "Aleskandro" Di Stefano,
# Davide "kk0nrad" Corrado
# patcher e contributors:
# Marco Placidi, Maurizio "Tannoiser" Lemmo, Matteo Panella
# Mattia Munari
# thanks to : Veteran Unix Admins group on Facebook
# released under GNU-GPLv3
############################################################
# parametri da command line:
# --angry: usa vere bestemmie
# --audio : attiva mplayer per fargli pronunciare i santi
# --spm <n> : numero di santi per minuto
# --wall : invia l'output a tutte le console : attenzione , se non siete root o sudoers disattivare il flag -n
# --nds <n> : numero di santi da invocare (di default continua all'infinito)
# --shutdown : se nds > 0 e si e` root al termine delle invocazioni spegne
# --off  : se si e` root invoca un solo santo e spegne (equivale a --nds 1 --shutdown)

ANGRY_ENABLED=false

AUDIO_ENABLED=false

SPM=1
SPM_ENABLED=false

POT=-1

NDS_ENABLED=false
NDS=-1

WALL_ENABLED=false

SHUTDOWN=false
OFF=false

SHUF_CMD="shuf"

DEFPLAYER="mplayer -cache 1024 -"
PLAYER="${PLAYER:-$DEFPLAYER}"
LC_CTYPE=C

if [ "$(uname)" = "Darwin" ]; then
	if ! command -v shuf >/dev/null 2>&1; then
		if ! command -v gshuf >/dev/null 2>&1; then
			echo "WARNING: Mannaggia requires shuf to work. Please install it."
			exit 2
		else
			SHUF_CMD=gshuf
		fi
	fi
else
	say() {
		if command -v say >/dev/null; then
			say "$1"
		else
			IFS=+
			mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$*&tl=it"
		fi
	}
fi

# lettura parametri da riga comando
for parm in "$@"; do
	# leggi dai parametri se sono consentite le vere bestemmie
	if [ "$parm" = "--angry" ]; then
		ANGRY_ENABLED=true
	fi

	# leggi dai parametri se c'e' l'audio
	if [ "$parm" = "--audio" ]; then
		which "$(echo "$PLAYER" | awk '{print $1}')" >/dev/null 2>&1 || {
			echo "Mannaggia requires an audio player to work. Please install mplayer." >&2
			exit 255
		}
		AUDIO_ENABLED=true
	fi

	# leggi dai parametri se c'e' da mandare i commenti su wall
	if [ "$parm" = "--wall" ]; then
		WALL_ENABLED=true
	fi

	# se spmflag
	# imposta i santi per minuto e resetta il flag
	if [ "$SPM_ENABLED" = true ]; then
		if [ "$parm" -lt 1 ]; then
			SPM=1
			SPM_ENABLED=false
		else
			SPM=$((60 / parm))
			SPM_ENABLED=false
		fi
	fi

	# se parm = --spm
	# setta il flag spmflag
	if [ "$parm" = "--spm" ]; then
		SPM_ENABLED=true
	fi

	# se ndsflag
	# imposta il numero di santi da ciclare
	if [ "$NDS_ENABLED" = true ]; then
		NDS="$parm"
		NDS_ENABLED=false
	fi

	# se parm = --nds
	# setta il flag NDS_ENABLED
	if [ "$parm" = "--nds" ]; then
		NDS_ENABLED=true
	fi

	# dipende da --nds
	if [ "$parm" = "--shutdown" ]; then
		SHUTDOWN=true
	fi

	# imposta off su true, successivamente nds viene sovrascritto a 1
	if [ "$parm" = "--off" ]; then
		OFF=true
	fi

done

if [ "$OFF" = true ]; then
	SHUTDOWN=true
	NDS=1
fi

while [ "$NDS" != 0 ]; do
	# Get a random swear word from opt
	opt="Mannaggia_a Porco La_miseria_di Vaffanculo Quel_mona_di_un"
	len=$(echo "$opt" | tr " " "\n" | wc -l)
	item=$((($(od -vAn -N4 -t u4 </dev/urandom) % len) + 1))
	word=$(echo "$opt" | tr " " "\n" | sed "s/_/ /g" | sed -n "$item"p)

	# If angry mode on, change
	if [ "$ANGRY_ENABLED" = "true" ]; then
		mannaggia=$(base64 --decode bestemmie.b64 | $SHUF_CMD | head -n 1)
	else
		mannaggia="${word} $($SHUF_CMD mannaggia.dat | head -n 1)"
	fi

	if [ "$WALL_ENABLED" = true ]; then
		POT=$((NDS % 50))
		if [ "$POT" = 0 ]; then
			echo "systemd merda, poettering vanaglorioso fonte di danni, ti strafulmini santa cunegonda bipalluta protrettice dei VUA"
		else
			# attenzione: se non siete root o sudoers dovete togliere dalla riga successiva "sudo" e "-n"
			echo "$mannaggia" | sudo wall -n
		fi
	else
		echo "$mannaggia" >/dev/stdout
	fi
	if [ "$AUDIO_ENABLED" = true ]; then
		say "$mannaggia" 2>/dev/null
	fi

	sleep "$SPM"
	NDS=$((NDS - 1))
done

if [ $SHUTDOWN = true -a $UID = 0 ]; then
	halt
fi
