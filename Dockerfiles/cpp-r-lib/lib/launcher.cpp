#include <unistd.h>
#include <cstdlib>
#include <iostream>

int main(int argc, char* argv[]) {
    setenv("LD_LIBRARY_PATH", "/usr/lib/R/lib:/usr/local/lib/R/site-library/RInside/lib", 1);

    if (argc < 2) {
        std::cerr << "[ERROR] Faltan argumentos. Uso: launcher script.R\n";
        return 1;
    }

    char* args[argc + 2];
    args[0] = (char*)"/opt/ignis/bin/r_demo";
    for (int i = 1; i < argc + 1; ++i) args[i] = argv[i];
    args[argc + 1] = nullptr;

    execv(args[0], args);
    perror("execv");
    return 1;
}
