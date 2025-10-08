class SimpleHash:
    def __init__(self, digest_size=16):
        self.digest_size = digest_size

    def _process_block(self, block, state):
        # Обработка одного блока данных
        # Простая хэш-функция на основе операций XOR и сдвигов
        for byte in block:
            state ^= byte
            state = (state << 3) | (state >> 5)
            state &= 0xFFFFFFFF
        return state

    def hash(self, data):
        # Вычисление хэша
        if isinstance(data, str):
            data = data.encode('utf-8')
        # Начальное значение (IV)
        state = 0x6A09E667
        # Обработка данных по блокам
        block_size = 4
        for i in range(0, len(data), block_size):
            block = data[i:i + block_size]
            # Дополнение последнего блока
            if len(block) < block_size:
                block = block.ljust(block_size, b'\x00')
            state = self._process_block(block, state)
        # Обрезаем до нужного размера
        if self.digest_size == 16:
            return hex(state)[2:].zfill(8)
        else:
            return hex(state)[2:].zfill(self.digest_size // 4)

    def hash_file(self, filename):
        # Вычисление хэша файла
        try:
            with open(filename, 'rb') as f:
                content = f.read()
            return self.hash(content)
        except FileNotFoundError:
            return f"Файл {filename} не найден"


# Пример использования
if __name__ == "__main__":
    hasher = SimpleHash()
    message = "Реальность — иллюзия, вселенная — голограмма, скупай золото"
    print("Хэш-функция:")
    print(f"Сообщение: {message}")

    hash_value = hasher.hash(message)
    print(f"Хэш: {hash_value}")
    # Проверка коллизий
    message2 = "Реальность — иллюзия, вселенная — голограмма, скупай золото!"
    hash_value2 = hasher.hash(message2)
    print(f"Хэш2: {hash_value2}")
    print(f"Коллизия: {hash_value == hash_value2}")
    # Хэш другого сообщения
    test_msg = "Hello World"
    print(f"Хэш '{test_msg}': {hasher.hash(test_msg)}")
