class SimpleHash:
    def __init__(self, output_bits=256):
        self.output_bits = output_bits
        self.output_bytes = output_bits // 8
        
    def hash(self, data):
        """Простая хэш-функция на основе операций XOR и сдвигов"""
        if isinstance(data, str):
            data = data.encode()
        
        # Инициализация хэш-значения
        hash_val = bytearray(b'\x00' * self.output_bytes)
        
        # Обработка данных блоками
        for i in range(0, len(data), self.output_bytes):
            block = data[i:i + self.output_bytes]
            block = block.ljust(self.output_bytes, b'\x00')
            
            # Применяем XOR и циклический сдвиг
            for j in range(self.output_bytes):
                hash_val[j] ^= block[j]
                hash_val[j] = ((hash_val[j] << 3) | (hash_val[j] >> 5)) & 0xFF
        
        # Дополнительное перемешивание
        for _ in range(3):
            for j in range(self.output_bytes):
                hash_val[j] = (hash_val[j] + hash_val[(j + 1) % self.output_bytes]) & 0xFF
                hash_val[j] = ((hash_val[j] << 5) | (hash_val[j] >> 3)) & 0xFF
        
        return bytes(hash_val)

def test_simple_hash():
    print("=== Тестирование простой хэш-функции ===")
    hasher = SimpleHash(256)
    
    message1 = "Реальность — иллюзия, вселенная — голограмма, скупай золото!"
    message2 = "Реальность — иллюзия, вселенная — голограмма, скупай золото"
    
    hash1 = hasher.hash(message1)
    hash2 = hasher.hash(message2)
    
    print(f"Сообщение 1: {message1}")
    print(f"Хэш 1: {hash1.hex()}")
    print(f"Сообщение 2: {message2}")
    print(f"Хэш 2: {hash2.hex()}")
    print(f"Хэши различны: {hash1 != hash2}")
    print()
