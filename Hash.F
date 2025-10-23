class SimpleHash:
    def __init__(self, output_bits=256):
        self.output_bits = output_bits
        self.output_bytes = output_bits // 8
        
    def hash(self, data):
        if isinstance(data, str):
            data = data.encode()
        hash_val = bytearray(b'\x00' * self.output_bytes)
        for i in range(0, len(data), self.output_bytes):
            block = data[i:i + self.output_bytes]
            block = block.ljust(self.output_bytes, b'\x00')
            for j in range(self.output_bytes):
                hash_val[j] ^= block[j]
                hash_val[j] = ((hash_val[j] << 3) | (hash_val[j] >> 5)) & 0xFF
        for _ in range(3):
            for j in range(self.output_bytes):
                hash_val[j] = (hash_val[j] + hash_val[(j + 1) % self.output_bytes]) & 0xFF
                hash_val[j] = ((hash_val[j] << 5) | (hash_val[j] >> 3)) & 0xFF
        return bytes(hash_val)


class StreamCipher:
    def __init__(self, key):
        self.key = key
        self.position = 0
        self.hasher = SimpleHash(256)
        
    def _key_stream(self, length):
        result = b''
        for i in range(length):
            data = self.key + str(self.position).encode()
            hash_val = self.hasher.hash(data)
            result += bytes([hash_val[0]])
            self.position += 1
        return result
    
    def encrypt(self, data):
        if isinstance(data, str):
            data = data.encode()
        key_stream = self._key_stream(len(data))
        encrypted = bytes([data[i] ^ key_stream[i] for i in range(len(data))])
        return encrypted
    
    def decrypt(self, encrypted_data):
        return self.encrypt(encrypted_data)


def interactive_cipher():
    print("=== Поточный шифр на основе SimpleHash ===")
    
    mode = input("Вы хотите зашифровать (e) или расшифровать (d)? \n").strip().lower()
    key = input("Введите ключ: \n").encode()
    cipher = StreamCipher(key)
    
    if mode == 'e':
        message = input("Введите сообщение для шифрования: \n")
        encrypted = cipher.encrypt(message)
        print(f"\nЗашифрованное (в hex): {encrypted.hex()}")
        
    elif mode == 'd':
        hex_data = input("Введите зашифрованный текст в hex: \n").strip()
        encrypted = bytes.fromhex(hex_data)
        decrypted = cipher.decrypt(encrypted)
        print(f"\nРасшифрованное сообщение: {decrypted.decode(errors='replace')}")
        
    else:
        print("Неверный выбор режима (используйте 'e' или 'd').")


if __name__ == "__main__":
    interactive_cipher()
