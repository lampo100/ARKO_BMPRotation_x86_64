#include <SFML/Graphics/RenderWindow.hpp>
#include <SFML/Window.hpp>
#include <SFML/Graphics/Texture.hpp>
#include <SFML/Graphics/Sprite.hpp>

extern "C" {
    void rotateL(uint8_t *input, uint8_t *output, uint32_t width, uint32_t height);
    void rotateUD(uint8_t *input, uint8_t *output, uint32_t width, uint32_t height);
    void rotateR(uint8_t *input, uint8_t *output, uint32_t width, uint32_t height);
};
int main(int argc, char **argv) {

    sf::Image image;
    sf::Texture texture;
    sf::Texture texture2;
    sf::Sprite sprite;
    sf::Sprite sprite2;
    int rotated = 0;

    image.loadFromFile(argv[1]);
    sf::Uint8 *pixelsInput = (sf::Uint8 *) image.getPixelsPtr();
    sf::Uint8 *pixelsOutputIL = new sf::Uint8[4 * image.getSize().x * image.getSize().y];
    sf::Uint8 *pixelsOutputIR = new sf::Uint8[4 * image.getSize().x * image.getSize().y];
    sf::Uint8 *pixelsOutputUD = new sf::Uint8[4 * image.getSize().x * image.getSize().y];
    rotateL(pixelsInput, pixelsOutputIL, image.getSize().x, image.getSize().y);
    rotateUD(pixelsInput, pixelsOutputUD, image.getSize().x, image.getSize().y);
    rotateR(pixelsInput, pixelsOutputIR, image.getSize().x, image.getSize().y);

    texture.create(image.getSize().x, image.getSize().y);
    texture2.create(image.getSize().y, image.getSize().x); // Obrócona o 90 stopni

    sprite.setTexture(texture);
    sprite2.setTexture(texture2); // Obrócone o 90 stopni

    sprite.setPosition(0, 0);
    sprite2.setPosition(0, 0);

    sf::RenderWindow window(sf::VideoMode(image.getSize().x, image.getSize().y), sf::String("ARKO - Obrot"));
    window.setFramerateLimit(60);
    window.setKeyRepeatEnabled(false);

    while(window.isOpen()) {
        sf::Event event;
        while(window.pollEvent(event)) {
            if(event.type == sf::Event::Closed) {
                window.close();
            }
            if ((event.type == sf::Event::KeyPressed)){
                if(event.key.code == sf::Keyboard::Left){
                    switch(rotated){
                        case 0: //original position
                            window.create(sf::VideoMode(image.getSize().y, image.getSize().x), sf::String("ARKO - Obrot"));
                            rotated = -1;
                            break;
                        case 1: // rotated right
                            window.create(sf::VideoMode(image.getSize().x, image.getSize().y), sf::String("ARKO - Obrot"));
                            rotated = 0;
                            break;
                        case -1: //rotated left
                            window.create(sf::VideoMode(image.getSize().x, image.getSize().y), sf::String("ARKO - Obrot"));
                            rotated = 2;
                            break;
                        case 2: //upside down
                            window.create(sf::VideoMode(image.getSize().y, image.getSize().x), sf::String("ARKO - Obrot"));
                            rotated = 1;
                            break;
                        }
                }
                if(event.key.code == sf::Keyboard::Right){
                    switch(rotated){
                        case 0: //original position
                            window.create(sf::VideoMode(image.getSize().y, image.getSize().x), sf::String("ARKO - Obrot"));
                            rotated = 1;
                            break;
                        case 1: // rotated right
                            window.create(sf::VideoMode(image.getSize().x, image.getSize().y), sf::String("ARKO - Obrot"));
                            rotated = 2;
                            break;
                        case -1: //rotated left
                            window.create(sf::VideoMode(image.getSize().x, image.getSize().y), sf::String("ARKO - Obrot"));
                            rotated = 0;
                            break;
                        case 2: //upside down
                            window.create(sf::VideoMode(image.getSize().y, image.getSize().x), sf::String("ARKO - Obrot"));
                            rotated = -1;
                            break;
                        }
                }
                if(event.key.code == sf::Keyboard::Escape){
                    window.close();
                }
            }
        }
        switch(rotated){
            case 0:
                texture.update(pixelsInput);
                window.clear(sf::Color::Black);
                window.draw(sprite);
                window.display();
                break;
            case 1:
                texture2.update(pixelsOutputIR);
                window.clear(sf::Color::Black);
                window.draw(sprite2);
                window.display();
                break;
            case -1:
                texture2.update(pixelsOutputIL);
                window.clear(sf::Color::Black);
                window.draw(sprite2);
                window.display();
                break;
            case 2:
                texture.update(pixelsOutputUD);
                window.clear(sf::Color::Black);
                window.draw(sprite);
                window.display();
                break;
        }
    }
    delete[] pixelsOutputIL;
    delete[] pixelsOutputUD;
    delete[] pixelsOutputIR;
    return 0;
}
