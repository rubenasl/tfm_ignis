#include <RInside.h>
#include <fstream>
#include <sstream>
#include <iostream>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cerr << "[ERROR] Debes pasar un script R como argumento.\n";
        std::cerr << "Uso: r_demo script.R\n";
        return 1;
    }

    std::ifstream file(argv[1]);
    if (!file.is_open()) {
        std::cerr << "[ERROR] No se pudo abrir el archivo: " << argv[1] << std::endl;
        return 1;
    }

    std::stringstream buffer;
    buffer << file.rdbuf();

    try {
        RInside R(argc, argv);
        R.parseEvalQ(buffer.str());
    } catch (std::exception &ex) {
        std::cerr << "[ERROR] Excepción de R: " << ex.what() << std::endl;
        return 1;
    }

    return 0;
}
