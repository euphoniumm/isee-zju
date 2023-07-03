#include "AES.hpp"

AES::AES(const AESKeyLength keyLength) {
    switch (keyLength) {
    case AESKeyLength::AES_128:
        this->Nk = 4;
        this->Nr = 10;
        break;
    case AESKeyLength::AES_192:
        this->Nk = 6;
        this->Nr = 12;
        break;
    case AESKeyLength::AES_256:
        this->Nk = 8;
        this->Nr = 14;
        break;
    }
}

byte* AES::EncryptECB(const byte in[], unsigned int inLen,
    const byte key[]) {
    CheckLength(inLen);
    byte* out = new byte[inLen];
    byte* roundKeys = new byte[4 * Nb * (Nr + 1)];
    KeyExpansion(key, roundKeys);
    for (unsigned int i = 0; i < inLen; i += blockBytesLen) {
        EncryptBlock(in + i, out + i, roundKeys);
    }

    delete[] roundKeys;

    return out;
}

byte* AES::DecryptECB(const byte in[], unsigned int inLen,
    const byte key[]) {
    CheckLength(inLen);
    byte* out = new byte[inLen];
    byte* roundKeys = new byte[4 * Nb * (Nr + 1)];
    KeyExpansion(key, roundKeys);
    for (unsigned int i = 0; i < inLen; i += blockBytesLen) {
        DecryptBlock(in + i, out + i, roundKeys);
    }

    delete[] roundKeys;

    return out;
}

byte* AES::EncryptCBC(const byte in[], unsigned int inLen,
    const byte key[],
    const byte* iv) {
    CheckLength(inLen);
    byte* out = new byte[inLen];
    byte block[blockBytesLen];
    byte* roundKeys = new byte[4 * Nb * (Nr + 1)];
    KeyExpansion(key, roundKeys);
    memcpy(block, iv, blockBytesLen);
    for (unsigned int i = 0; i < inLen; i += blockBytesLen) {
        XorBlocks(block, in + i, block, blockBytesLen);
        EncryptBlock(block, out + i, roundKeys);
        memcpy(block, out + i, blockBytesLen);
    }

    delete[] roundKeys;

    return out;
}

byte* AES::DecryptCBC(const byte in[], unsigned int inLen,
    const byte key[],
    const byte* iv) {
    CheckLength(inLen);
    byte* out = new byte[inLen];
    byte block[blockBytesLen];
    byte* roundKeys = new byte[4 * Nb * (Nr + 1)];
    KeyExpansion(key, roundKeys);
    memcpy(block, iv, blockBytesLen);
    for (unsigned int i = 0; i < inLen; i += blockBytesLen) {
        DecryptBlock(in + i, out + i, roundKeys);
        XorBlocks(block, out + i, out + i, blockBytesLen);
        memcpy(block, in + i, blockBytesLen);
    }

    delete[] roundKeys;

    return out;
}

byte* AES::EncryptCFB(const byte in[], unsigned int inLen,
    const byte key[],
    const byte* iv) {
    CheckLength(inLen);
    byte* out = new byte[inLen];
    byte block[blockBytesLen];
    byte encryptedBlock[blockBytesLen];
    byte* roundKeys = new byte[4 * Nb * (Nr + 1)];
    KeyExpansion(key, roundKeys);
    memcpy(block, iv, blockBytesLen);
    for (unsigned int i = 0; i < inLen; i += blockBytesLen) {
        EncryptBlock(block, encryptedBlock, roundKeys);
        XorBlocks(in + i, encryptedBlock, out + i, blockBytesLen);
        memcpy(block, out + i, blockBytesLen);
    }

    delete[] roundKeys;

    return out;
}

byte* AES::DecryptCFB(const byte in[], unsigned int inLen,
    const byte key[],
    const byte* iv) {
    CheckLength(inLen);
    byte* out = new byte[inLen];
    byte block[blockBytesLen];
    byte encryptedBlock[blockBytesLen];
    byte* roundKeys = new byte[4 * Nb * (Nr + 1)];
    KeyExpansion(key, roundKeys);
    memcpy(block, iv, blockBytesLen);
    for (unsigned int i = 0; i < inLen; i += blockBytesLen) {
        EncryptBlock(block, encryptedBlock, roundKeys);
        XorBlocks(in + i, encryptedBlock, out + i, blockBytesLen);
        memcpy(block, in + i, blockBytesLen);
    }

    delete[] roundKeys;

    return out;
}

void AES::CheckLength(unsigned int len) {
    if (len % blockBytesLen != 0) {
        throw std::length_error("Plaintext length must be divisible by " +
            std::to_string(blockBytesLen));
    }
}

void AES::EncryptBlock(const byte in[], byte out[],
    byte* roundKeys) {
    byte state[4][Nb];
    unsigned int i, j, round;

    for (i = 0; i < 4; i++) {
        for (j = 0; j < Nb; j++) {
            state[i][j] = in[i + 4 * j];
        }
    }

    AddRoundKey(state, roundKeys);

    for (round = 1; round <= Nr - 1; round++) {
        SubBytes(state);
        ShiftRows(state);
        MixColumns(state);
        AddRoundKey(state, roundKeys + round * 4 * Nb);
    }

    SubBytes(state);
    ShiftRows(state);
    AddRoundKey(state, roundKeys + Nr * 4 * Nb);

    for (i = 0; i < 4; i++) {
        for (j = 0; j < Nb; j++) {
            out[i + 4 * j] = state[i][j];
        }
    }
}

void AES::DecryptBlock(const byte in[], byte out[],
    byte* roundKeys) {
    byte state[4][Nb];
    unsigned int i, j, round;

    for (i = 0; i < 4; i++) {
        for (j = 0; j < Nb; j++) {
            state[i][j] = in[i + 4 * j];
        }
    }

    AddRoundKey(state, roundKeys + Nr * 4 * Nb);

    for (round = Nr - 1; round >= 1; round--) {
        InvSubBytes(state);
        InvShiftRows(state);
        AddRoundKey(state, roundKeys + round * 4 * Nb);
        InvMixColumns(state);
    }

    InvSubBytes(state);
    InvShiftRows(state);
    AddRoundKey(state, roundKeys);

    for (i = 0; i < 4; i++) {
        for (j = 0; j < Nb; j++) {
            out[i + 4 * j] = state[i][j];
        }
    }
}

void AES::SubBytes(byte state[4][Nb]) {
    unsigned int i, j;
    byte t;
    for (i = 0; i < 4; i++) {
        for (j = 0; j < Nb; j++) {
            t = state[i][j];
            state[i][j] = sbox[t / 16][t % 16];
        }
    }
}

void AES::ShiftRow(byte state[4][Nb], unsigned int i,
    unsigned int n)  // shift row i on n positions
{
    byte tmp[Nb];
    for (unsigned int j = 0; j < Nb; j++) {
        tmp[j] = state[i][(j + n) % Nb];
    }
    memcpy(state[i], tmp, Nb * sizeof(byte));
}

void AES::ShiftRows(byte state[4][Nb]) {
    ShiftRow(state, 1, 1);
    ShiftRow(state, 2, 2);
    ShiftRow(state, 3, 3);
}

byte AES::xtime(byte b)  // multiply on x
{
    return (b << 1) ^ (((b >> 7) & 1) * 0x1b);
}

void AES::MixColumns(byte state[4][Nb]) {
    byte temp_state[4][Nb];

    for (size_t i = 0; i < 4; ++i) {
        memset(temp_state[i], 0, 4);
    }

    for (size_t i = 0; i < 4; ++i) {
        for (size_t k = 0; k < 4; ++k) {
            for (size_t j = 0; j < 4; ++j) {
                if (CMDS[i][k] == 1)
                    temp_state[i][j] ^= state[k][j];
                else
                    temp_state[i][j] ^= GF_MUL_TABLE[CMDS[i][k]][state[k][j]];
            }
        }
    }

    for (size_t i = 0; i < 4; ++i) {
        memcpy(state[i], temp_state[i], 4);
    }
}

void AES::AddRoundKey(byte state[4][Nb], byte* key) {
    unsigned int i, j;
    for (i = 0; i < 4; i++) {
        for (j = 0; j < Nb; j++) {
            state[i][j] = state[i][j] ^ key[i + 4 * j];
        }
    }
}

void AES::SubWord(byte* a) {
    int i;
    for (i = 0; i < 4; i++) {
        a[i] = sbox[a[i] / 16][a[i] % 16];
    }
}

void AES::RotWord(byte* a) {
    byte c = a[0];
    a[0] = a[1];
    a[1] = a[2];
    a[2] = a[3];
    a[3] = c;
}

void AES::XorWords(byte* a, byte* b, byte* c) {
    int i;
    for (i = 0; i < 4; i++) {
        c[i] = a[i] ^ b[i];
    }
}

void AES::Rcon(byte* a, unsigned int n) {
    unsigned int i;
    byte c = 1;
    for (i = 0; i < n - 1; i++) {
        c = xtime(c);
    }

    a[0] = c;
    a[1] = a[2] = a[3] = 0;
}

void AES::KeyExpansion(const byte key[], byte w[]) {
    byte temp[4];
    byte rcon[4];

    unsigned int i = 0;
    while (i < 4 * Nk) {
        w[i] = key[i];
        i++;
    }

    i = 4 * Nk;
    while (i < 4 * Nb * (Nr + 1)) {
        temp[0] = w[i - 4 + 0];
        temp[1] = w[i - 4 + 1];
        temp[2] = w[i - 4 + 2];
        temp[3] = w[i - 4 + 3];

        if (i / 4 % Nk == 0) {
            RotWord(temp);
            SubWord(temp);
            Rcon(rcon, i / (Nk * 4));
            XorWords(temp, rcon, temp);
        }
        else if (Nk > 6 && i / 4 % Nk == 4) {
            SubWord(temp);
        }

        w[i + 0] = w[i - 4 * Nk] ^ temp[0];
        w[i + 1] = w[i + 1 - 4 * Nk] ^ temp[1];
        w[i + 2] = w[i + 2 - 4 * Nk] ^ temp[2];
        w[i + 3] = w[i + 3 - 4 * Nk] ^ temp[3];
        i += 4;
    }
}

void AES::InvSubBytes(byte state[4][Nb]) {
    unsigned int i, j;
    byte t;
    for (i = 0; i < 4; i++) {
        for (j = 0; j < Nb; j++) {
            t = state[i][j];
            state[i][j] = inv_sbox[t / 16][t % 16];
        }
    }
}

void AES::InvMixColumns(byte state[4][Nb]) {
    byte temp_state[4][Nb];

    for (size_t i = 0; i < 4; ++i) {
        memset(temp_state[i], 0, 4);
    }

    for (size_t i = 0; i < 4; ++i) {
        for (size_t k = 0; k < 4; ++k) {
            for (size_t j = 0; j < 4; ++j) {
                temp_state[i][j] ^= GF_MUL_TABLE[INV_CMDS[i][k]][state[k][j]];
            }
        }
    }

    for (size_t i = 0; i < 4; ++i) {
        memcpy(state[i], temp_state[i], 4);
    }
}

void AES::InvShiftRows(byte state[4][Nb]) {
    ShiftRow(state, 1, Nb - 1);
    ShiftRow(state, 2, Nb - 2);
    ShiftRow(state, 3, Nb - 3);
}

void AES::XorBlocks(const byte* a, const byte* b,
    byte* c, unsigned int len) {
    for (unsigned int i = 0; i < len; i++) {
        c[i] = a[i] ^ b[i];
    }
}

void AES::printHexArray(byte a[], unsigned int n) {
    for (unsigned int i = 0; i < n; i++) {
        printf("%02x ", a[i]);
    }
}

void AES::printHexVector(std::vector<byte> a) {
    for (unsigned int i = 0; i < a.size(); i++) {
        printf("%02x ", a[i]);
    }
}

std::vector<byte> AES::ArrayToVector(byte* a,
    unsigned int len) {
    std::vector<byte> v(a, a + len * sizeof(byte));
    return v;
}

byte* AES::VectorToArray(std::vector<byte>& a) {
    return a.data();
}

std::vector<byte> AES::EncryptECB(std::vector<byte> in,
    std::vector<byte> key) {
    byte* out = EncryptECB(VectorToArray(in), (unsigned int)in.size(),
        VectorToArray(key));
    std::vector<byte> v = ArrayToVector(out, in.size());
    delete[] out;
    return v;
}

std::vector<byte> AES::DecryptECB(std::vector<byte> in,
    std::vector<byte> key) {
    byte* out = DecryptECB(VectorToArray(in), (unsigned int)in.size(),
        VectorToArray(key));
    std::vector<byte> v = ArrayToVector(out, (unsigned int)in.size());
    delete[] out;
    return v;
}

std::vector<byte> AES::EncryptCBC(std::vector<byte> in,
    std::vector<byte> key,
    std::vector<byte> iv) {
    byte* out = EncryptCBC(VectorToArray(in), (unsigned int)in.size(),
        VectorToArray(key), VectorToArray(iv));
    std::vector<byte> v = ArrayToVector(out, in.size());
    delete[] out;
    return v;
}

std::vector<byte> AES::DecryptCBC(std::vector<byte> in,
    std::vector<byte> key,
    std::vector<byte> iv) {
    byte* out = DecryptCBC(VectorToArray(in), (unsigned int)in.size(),
        VectorToArray(key), VectorToArray(iv));
    std::vector<byte> v = ArrayToVector(out, (unsigned int)in.size());
    delete[] out;
    return v;
}

std::vector<byte> AES::EncryptCFB(std::vector<byte> in,
    std::vector<byte> key,
    std::vector<byte> iv) {
    byte* out = EncryptCFB(VectorToArray(in), (unsigned int)in.size(),
        VectorToArray(key), VectorToArray(iv));
    std::vector<byte> v = ArrayToVector(out, in.size());
    delete[] out;
    return v;
}

std::vector<byte> AES::DecryptCFB(std::vector<byte> in,
    std::vector<byte> key,
    std::vector<byte> iv) {
    byte* out = DecryptCFB(VectorToArray(in), (unsigned int)in.size(),
        VectorToArray(key), VectorToArray(iv));
    std::vector<byte> v = ArrayToVector(out, (unsigned int)in.size());
    delete[] out;
    return v;
}