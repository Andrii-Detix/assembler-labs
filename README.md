# Practice with assembler

This project is my solution to a lab work as a student of the Faculty of Informatics and Computer Engineering (FICE) at the Kyiv Polytechnic Institute (KPI).

The two files are solutions to the same task – displaying a message in a MessageBox. However, one file is written in MASM32, while the other is in MASM64.

## Build and Run

### MASM32

1. Install MASM32

2. Clone the repository: 
    ```bash
    git clone https://github.com/Andrii-Detix/assembler-lab1
    ```

3. Navigate to the project directory:
    ```bash
    cd assembler-lab1
    ```

4. Build the project:
    ```bash
    ml /c /coff masm32.asm
    link32 /subsystem:windows masm32.obj
    ```

5. Open `masm32.exe` file

### MASM64

1. Install MASM64

2. Clone the repository: 
    ```bash
    git clone https://github.com/Andrii-Detix/assembler-lab1
    ```

3. Navigate to the project directory:
    ```bash
    cd assembler-lab1
    ```

4. Build the project:
    ```bash
    ml64 /c masm64.asm
    link /subsystem:windows /entry:Main masm64.obj
    ```

5. Open `masm64.exe` file

## Author

Developed by [Andrii Ivanchyshyn](https://github.com/Andrii-Detix/Sliding_Puzzle_Project/commits?author=Andrii-Detix).
