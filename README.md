# Practice with assembler

This project is my solution to a lab works as a student of the Faculty of Informatics and Computer Engineering (FICE) at the Kyiv Polytechnic Institute (KPI).

## Build and Run

### MASM32

1. Install MASM32

2. Clone the repository: 
    ```bash
    git clone https://github.com/Andrii-Detix/assembler-labs.git
    ```

3. Navigate to the project directory:
    ```bash
    cd assembler-labs
    ```

4. Build the project:
    ```bash
    ml /c /coff <file-name>.asm
    link32 /subsystem:windows <file-name>.obj
    ```

    If you need to generate an extended listing, add the `/Fl` switch. If you want macros to appear in the listing, also add `/Fm`.
    ```bash
    ml /c /coff /Fl /Fm <file-name>.asm
    ```

5. Open `<file-name>.exe` file

### MASM64

1. Install MASM64

2. Clone the repository: 
    ```bash
    git clone https://github.com/Andrii-Detix/assembler-labs.git
    ```

3. Navigate to the project directory:
    ```bash
    cd assembler-labs
    ```

4. Build the project:
    ```bash
    ml64 /c <file-name>.asm
    link /subsystem:windows /entry:Main <file-name>.obj
    ```

5. Open `<file-name>.exe` file

## Author

Developed by [Andrii Ivanchyshyn](https://github.com/Andrii-Detix/Sliding_Puzzle_Project/commits?author=Andrii-Detix).
