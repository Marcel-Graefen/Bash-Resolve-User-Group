# 📋 Bash User and Group Resolver

![Version](https://img.shields.io/badge/version-0.0.1-blue.svg)
[![German](https://img.shields.io/badge/Language-German-blue)](./README.de.md)
![GitHub last commit](https://img.shields.io/github/last-commit/Marcel-Graefen/Bash-INI-Parser)
[![Author](https://img.shields.io/badge/author-Marcel%20Gr%C3%A4fen-green.svg)](#-author--contact)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)
![](https://komarev.com/ghpvc/?username=Marcel-Graefen)

A robust and flexible Bash function that validates and resolves user and group information to ensure consistent ownership variables (`SET_USER`, `SET_GROUP`, etc.).

-----

## 🚀 Table of Contents

  * [📋 Features](#-features)
  * [⚙️ Prerequisites](##%EF%B8%8F-prerequisites)
  * [🚀 Usage](#-usage)
    * [Determining User and Group Information](determining-user-and-group-information)
  * [📌 API Reference](#-api-reference)
    * [resolve_user_and_group](#-resolve_user_and_group)
    * [Global Variables Used](#-global-variables-used)
    * [👤 Author & Contact](#-author-and-contact)
  * [🤖 Generation Note](#-generation-note)
  * [📜 License](#-license)

-----

## 📋 Features

  * **Intelligent Fallback:** Automatically falls back to the default user (`SUDO_USER` or `$USER`) if the specified values are invalid.
  * **Consistent Variables:** Ensures that the global variables (`SET_USER`, `SET_UID`, `SET_GROUP`, `SET_GID`) always contain valid and consistent values.
  * **ID or Name Resolution:** Accepts both user/group names (`SET_USER`, `SET_GROUP`) and numerical IDs (`SET_UID`, `SET_GID`).
  * **Helpful Warnings:** Outputs warning messages when a fallback to default values is necessary.
  * **Bash 3.0+ Support:** The script is compatible with common and modern Bash versions.
  * **Show Warning Option** The script has a global variable to enable or disable `Terminal` warnings.


-----

## ⚙️ Prerequisites

  * **Bash** version 3.0 or higher.
  * Standard Unix utilities such as `id` and `getent`.

-----

## 🚀 Usage

The `resolve_user_and_group` function is typically called at the beginning of a script that needs to manage file ownership or permissions. The function checks existing variables and sets the final values.

### Determining User and Group Information

Here are some examples showing how the function sets the variables based on different starting conditions.

**Case 1: Normal Call Without Presets**

```bash
#!/usr/bin/env bash

# Before the call
echo "SET_USER: $SET_USER"  # Output: (empty)

# Function call
resolve_user_and_group

# After the call (logged in as user 'frank')
echo "SET_USER: $SET_USER"    # Output: frank
echo "SET_GROUP: $SET_GROUP"   # Output: frank
```

**Case 2: Call with a Predefined, Valid User Name**

```bash
#!/usr/bin/env bash

# Preset
SET_USER="www-data"

# Function call
resolve_user_and_group

# After the call
echo "SET_USER: $SET_USER"    # Output: www-data
echo "SET_UID: $SET_UID"      # Output: 33
echo "SET_GROUP: $SET_GROUP"   # Output: www-data
```

**Case 3: Call with an Invalid User Name (Fallback)**

```bash
#!/usr/bin/env bash

# Presets
SET_USER="non-existent-user"
SHOW_WARNING="true"

# Function call (logged in as user 'frank')
resolve_user_and_group

# After the call
echo "SET_USER: $SET_USER"    # Output: frank
# Console output: "Warning: USER did not exist, switched to default USER 'frank'."
```

-----

## 📌 API Reference

### `resolve_user_and_group`

This function validates and sets the global variables for the user and group. It takes no arguments as it directly accesses the global variables `SET_USER`, `SET_UID`, `SET_GROUP`, and `SET_GID`.

**Syntax:**

```bash
resolve_user_and_group
```

### Global Variables Used

The function interacts with the following global variables:

  * **`SET_USER`**: Can be predefined with a username. After the call, it contains the validated username.
  * **`SET_UID`**: Can be predefined with a numerical user ID. After the call, it contains the validated UID.
  * **`SET_GROUP`**: Can be predefined with a group name. After the call, it contains the validated group name.
  * **`SET_GID`**: Can be predefined with a numerical group ID. After the call, it contains the validated GID.
  * **`SHOW_WARNING`**: An optional variable. If set to `"true"`, the function outputs warnings during fallback scenarios.


> ⚠️ **Note:** The check for `SHOW_WARNING` is a reverse query. Only when `SHOW_WARNING == false` is no warning issued.

-----

## 👤 Author & Contact

  * **Marcel Gräfen**
  * 📧 [info@mgraefen.com](mailto:info@mgraefen.com)

  ---

## 🤖 Generation Note

This project was developed with the help of Artificial Intelligence (AI). The AI assisted in creating the script, comments, and documentation (`README.md`). The final result was reviewed and adjusted by me.

-----

## 📜 License

[MIT License](https://www.google.com/search?q=LICENSE)
