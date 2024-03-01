#!/bin/sh

# Game types:
#
# XGame.xDeathMatch			Standard DeathMatch
# BonusPack.xLastManStandingGame	Last Man Standing
# XGame.xTeamGame			Team DeathMatch
# Onslaught.ONSOnslaughtGame		Onslaught
# XGame.xBombingRun			Bombing Run
# SkaarjPack.Invasion			Invasion
# XGame.xVehicleCTFGame			Vehicle CTF
# UT2K4Assault.ASGameInfo		Assault
# XGame.xDoubleDom			Double Domination
# BonusPack.xMutantGame			Mutant
# XGame.xCTFGame			Capture The Flag
#
#
# Mutators.
#
# XWeapons.MutArena			Arena
# UnrealGame.MutBigHead			Big Head
# XGame.MutHeliumCorpses		Float-Away Corpses
# XGame.MutInstaGibS			Instagib
# XGame.MutZoomInstaGib			Zoom Instagib
# UnrealGame.MutLowGrav			Low Gravity
# XGame.MutNoAdrenaline			No Adrenaline
# XWeapons.MutNoSuperWeapon		No Super Weapons
# XGame.MutQuadJump			Quad Jump
# XGame.MutRegen			Auto Healing
# XGame.MutSlomoDeath			Slow Motion Deaths
# XGame.MutSpeciesStats			Species Specific Stats
# XGame.MutVampire			Vampire
# UT2004RPG.MutUT2004RPG
################################################################
#
# Stuff you will probably want to change.
#
# GAMEDIR - point it to the directory in which the server is installed
# INIFILE - the .ini file your server uses
# ADMINNAME - the 'name' of your webadmin user, if you use web admin
# ADMINPASS - the password for your webadmin user, if you use web admin
#
GAMEDIR=/home/container
INIFILE=${GAMEDIR}/System/UT2004.ini
ADMINNAME='AdminName='${4}
ADMINPASS='AdminPassword='${5}
#
#
# Game types which are used by this script.  Change as desired, but be
# aware of the consequences.  They work fine as is.
#
DEATHMATCH='DM-Rankin?game=XGame.xDeathMatch'
LASTMANSTANDING='DM-Morpheus3?game=BonusPack.xLastManStandingGame'
TEAMDEATHMATCH='DM-Rankin?game=XGame.xTeamGame'
ONSLAUGHT='ONS-Torlan?game=Onslaught.ONSOnslaughtGame'
BOMBINGRUN='BR-Anubis?game=XGame.xBombingRun'
INVASION='ONS-Torlan?game=SkaarjPack.Invasion'
ASSAULT='DM-Antalus?UT2K4Assault.ASGameInfo'
DOUBLEDOM='DOM-SunTemple?game=xGame.xDoubleDom'
MUTANT='DM-Morpheus3?game=BonusPack.xMutantGame'
CTF='CTF-Orbital2?game=XGame.xCTFGame'

#
# Set your Mutators
# 
MUTATORS='Mutator=XGame.MutFastWeapSwitch'

#
# Files.
#
LOGDIR=${GAMEDIR}/logs
SERVER=${GAMEDIR}/System/ucc-bin
LOG=${GAMEDIR}/ut2004-server.log
RLOG=${GAMEDIR}/ut2004-restart.log
SLOG=ut2004-server.log
CACHERECORD=${GAMEDIR}/System/CacheRecords.ucl
CACHEBACKUP=${GAMEDIR}/System/CacheRecords.bak

# How many times to loop & restart if the server dies.  To disable looping,
# set this to 1.
#
LOOPS=4

#
# Check for one command line argument, which is a gametype.
#
if [ $# -lt 1 ]; then
	echo ""
	echo "Usage: $0 gametype"
	echo ""
	echo "Valid gametypes are:"
	echo ""
	echo "   deathmatch (dm)"
	echo "   lastmanstanding (lms)"
	echo "   teamdeathmatch (tdm)"
	echo "   onslaught (ons)"
	echo "   bombingrun (bomb)"
	echo "   invasion (inv)"
	echo "   assault (aslt)"
	echo "   doubledom (dd)"
	echo "   mutant (mut)"
	echo "   capturetheflag (ctf)"
	echo ""
	exit 1
else
	case $1 in 
		deathmatch|dm)		GAMETYPE=${DEATHMATCH} ;;
		lastmanstanding|lms)	GAMETYPE=${LASTMANSTANDING} ;;
		teamdeathmatch|tdm)	GAMETYPE=${TEAMDEATHMATCH} ;;
		onslaught|ons)		GAMETYPE=${ONSLAUGHT} ;;
		bombingrun|bomb)	GAMETYPE=${BOMBINGRUN} ;;
		invasion|inv)		GAMETYPE=${INVASION} ;;
        fraghouseinvasion|fhi)		GAMETYPE=${FHI} ;;
		assault|aslt)		GAMETYPE=${ASSAULT} ;;
		doubledom|dd)		GAMETYPE=${DOUBLEDOM} ;;
		mutant|mut)		GAMETYPE=${MUTANT} ;;
		capturetheflag|ctf)	GAMETYPE=${CTF} ;;
		*)	echo "$1 - invalid gametype."
			exit 1 ;;
	esac
fi

sed -i "/^Port=/s/Port=.*/Port=${2}/" "${INIFILE}"
sed -i "/^ListenPort=/s/ListenPort=.*/ListenPort=${3}/" "${INIFILE}"

echo "Starting ut2004 server"
cd ./System/
./ucc-bin server "${GAMETYPE}?${ADMINNAME}?${ADMINPASS}?${MUTATORS} -ini=${INIFILE} -nohomedir"
