# 📋 Bash User and Group Resolver

![Version](https://img.shields.io/badge/version-0.0.1-blue.svg)
[![English](https://img.shields.io/badge/Sprache-English-blue)](./README.md)
![GitHub last commit](https://img.shields.io/github/last-commit/Marcel-Graefen/Bash-INI-Parser)
[![Author](https://img.shields.io/badge/author-Marcel%20Gr%C3%A4fen-green.svg)](#-author--contact)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)
![](https://komarev.com/ghpvc/?username=Marcel-Graefen)

Eine robuste und flexible Bash-Funktion, die Benutzer- und Gruppeninformationen validiert und auflöst, um konsistente Besitzervariablen (`SET_USER`, `SET_GROUP`, etc.) zu gewährleisten.

-----

## 🚀 Inhaltsverzeichnis

  * [📋 Features](#-features)
  * [⚙️ Voraussetzungen](#%EF%B8%8F-voraussetzungen)
  * [🚀 Nutzung](#-nutzung)
    * [Ermittlung von Benutzer- und Gruppeninformationen](#-ermittlung-von-benutzer--und-gruppeninformationen)
  * [📌 API-Referenz](#-api-referenz)
    * [resolve_user_and_group](#-resolve_user_and_group)
    * [Verwendete globale Variablen](#-verwendete-globale-variablen)
  * [👤 Autor & Kontakt](#-autor--kontakt)
  * [🤖 Generierungshinweis](#-generierungshinweis)
  * [📜 Lizenz](#-lizenz)

-----

## 📋 Features

  * **Intelligenter Fallback:** Fällt automatisch auf den Standardbenutzer (`SUDO_USER` oder `$USER`) zurück, wenn die angegebenen Werte ungültig sind.
  * **Konsistente Variablen:** Stellt sicher, dass die globalen Variablen (`SET_USER`, `SET_UID`, `SET_GROUP`, `SET_GID`) immer gültige und konsistente Werte enthalten.
  * **ID- oder Namensauflösung:** Akzeptiert sowohl Benutzer-/Gruppennamen (`SET_USER`, `SET_GROUP`) als auch numerische IDs (`SET_UID`, `SET_GID`).
  * **Hilfreiche Warnungen:** Gibt Warnmeldungen aus, wenn ein Fallback auf Standardwerte erforderlich ist.
  * **Bash 3.0+ Unterstützung:** Das Skript ist kompatibel mit gängigen und modernen Bash-Versionen.

-----

## ⚙️ Voraussetzungen

  * **Bash** Version 3.0 oder höher.
  * Standard-Unix-Dienstprogramme wie `id` und `getent`.

-----

## 🚀 Nutzung

Die Funktion `resolve_user_and_group` wird typischerweise am Anfang eines Skripts aufgerufen, das Dateibesitzer oder Berechtigungen verwalten muss. Die Funktion prüft vorhandene Variablen und setzt die endgültigen Werte.

### Ermittlung von Benutzer- und Gruppeninformationen

Hier sind einige Beispiele, die zeigen, wie die Funktion die Variablen setzt, basierend auf verschiedenen Startbedingungen.

**Fall 1: Normaler Aufruf ohne Voreinstellungen**

```bash
#!/usr/bin/env bash

# Vor dem Aufruf
echo "SET_USER: $SET_USER"  # Ausgabe: (leer)

# Funktionsaufruf
resolve_user_and_group

# Nach dem Aufruf (als Benutzer 'frank' angemeldet)
echo "SET_USER: $SET_USER"    # Ausgabe: frank
echo "SET_GROUP: $SET_GROUP"   # Ausgabe: frank
```

**Fall 2: Aufruf mit einem vordefinierten, gültigen Benutzernamen**

```bash
#!/usr/bin/env bash

# Voreinstellung
SET_USER="www-data"

# Funktionsaufruf
resolve_user_and_group

# Nach dem Aufruf
echo "SET_USER: $SET_USER"    # Ausgabe: www-data
echo "SET_UID: $SET_UID"      # Ausgabe: 33
echo "SET_GROUP: $SET_GROUP"   # Ausgabe: www-data
```

**Fall 3: Aufruf mit einem ungültigen Benutzernamen (Fallback)**

```bash
#!/usr/bin/env bash

# Voreinstellungen
SET_USER="nicht-existenter-benutzer"
SHOW_WARNING="true"

# Funktionsaufruf (als Benutzer 'frank' angemeldet)
resolve_user_and_group

# Nach dem Aufruf
echo "SET_USER: $SET_USER"    # Ausgabe: frank
# Konsolenausgabe: "Warning: USER did not exist, switched to default USER 'frank'."
```

-----

## 📌 API-Referenz

### `resolve_user_and_group`

Diese Funktion validiert und setzt die globalen Variablen für Benutzer und Gruppe. Sie nimmt keine Argumente entgegen, da sie direkt auf die globalen Variablen `SET_USER`, `SET_UID`, `SET_GROUP` und `SET_GID` zugreift.

**Syntax:**

```bash
resolve_user_and_group
```

### Verwendete globale Variablen

Die Funktion interagiert mit den folgenden globalen Variablen:

  * **`SET_USER`**: Kann mit einem Benutzernamen vordefiniert werden. Nach dem Aufruf enthält es den validierten Benutzernamen.
  * **`SET_UID`**: Kann mit einer numerischen Benutzer-ID vordefiniert werden. Nach dem Aufruf enthält es die validierte UID.
  * **`SET_GROUP`**: Kann mit einem Gruppennamen vordefiniert werden. Nach dem Aufruf enthält es den validierten Gruppennamen.
  * **`SET_GID`**: Kann mit einer numerischen Gruppen-ID vordefiniert werden. Nach dem Aufruf enthält es die validierte GID.
  * **`SHOW_WARNING`**: Eine optionale Variable. Wenn sie auf `"true"` gesetzt ist, gibt die Funktion Warnungen bei Fallback-Szenarien aus.

-----

## 👤 Autor & Kontakt

  * **Marcel Gräfen**
  * 📧 [info@mgraefen.com](mailto:info@mgraefen.com)

  ---

## 🤖 Generierungshinweis

Dieses Projekt wurde mithilfe einer Künstlichen Intelligenz (KI) entwickelt. Die KI hat bei der Erstellung des Skripts, der Kommentare und der Dokumentation (README.md) geholfen. Das endgültige Ergebnis wurde von mir überprüft und angepasst.

-----

## 📜 Lizenz

[MIT Lizenz](https://www.google.com/search?q=LICENSE)
