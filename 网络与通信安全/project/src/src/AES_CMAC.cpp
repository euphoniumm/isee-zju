#include "AES_CMAC.hpp"

AesCmac::AesCmac(AES& cipher, std::vector<byte> key)
{
    this->cipher = cipher;
    this->key = key;
}

std::vector<byte> AesCmac::xorBits(std::vector<byte> x, std::vector<byte> y)
{
    size_t len = x.size();
    if (y.size() != len)
    {
        printf("[ERROR] xorBits: Arg size mismatch.\n");
        exit(1);
    }

    std::vector<byte> result;

    for (size_t i = 0; i < len; i++)
    {
        result.push_back(x.at(i) ^ y.at(i));
    }

    return result;
}

std::vector<byte> AesCmac::shiftBitsLeft(std::vector<byte> x, size_t n)
{
    std::vector<byte> result;
    byte previous = 0x00;

    for (size_t i = x.size(); i > 0; i--)
    {
        byte current = x.at(i - 1);
        result.insert(result.begin(), (current << n) | (previous >> (8 - n)));
        previous = current;
    }

    return result;
}

void AesCmac::padBytes(std::vector<byte> &x)
{
    x.push_back(0x80);

    size_t x_len = x.size();
    size_t pad_len = BLOCK_BYTES_LENGTH - x_len;

    for (size_t i = 0; i < pad_len; i++)
    {
        x.push_back(0x00);
    }
}

std::pair<std::vector<byte>, std::vector<byte>> AesCmac::generateSubkeys(void)
{
    std::pair<std::vector<byte>, std::vector<byte>> subkeys;

    const std::vector<unsigned char> ZEROS = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    const std::vector<unsigned char> R_B = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                             0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x87 };


    std::vector<byte> k0 = this->cipher.EncryptECB(ZEROS, this->key);
    
    if ((k0.at(0) & MSB_BYTE_MASK) == 0x00)
    {
        subkeys.first = shiftBitsLeft(k0, 1);
    }
    else
    {
        subkeys.first = xorBits(shiftBitsLeft(k0, 1), R_B);
    }

    if ((subkeys.first.at(0) & MSB_BYTE_MASK) == 0x00)
    {
        subkeys.second = shiftBitsLeft(subkeys.first, 1);
    }
    else
    {
        subkeys.second = xorBits(shiftBitsLeft(subkeys.first, 1), R_B);
    }

    return subkeys;
}

std::vector<byte> AesCmac::generateCmac(std::vector<byte> message)
{
    std::pair<std::vector<byte>, std::vector<byte>> subkeys = generateSubkeys();

    std::vector<std::vector<byte>> M;
    std::vector<byte> block;

    size_t msg_len = message.size();
    bool last_block_complete;
    
    if ( (msg_len > 0) && ((msg_len % BLOCK_BYTES_LENGTH) == 0) )
    {
        last_block_complete = true;
    }
    else
    {
        last_block_complete = false;
    }

    for (size_t msg_byte_idx = 0; msg_byte_idx < msg_len; msg_byte_idx++)
    {
        block.push_back(message.at(msg_byte_idx));

        if (block.size() == BLOCK_BYTES_LENGTH)
        {
            M.push_back(block);
            block.clear();
        }
    }

    if (last_block_complete == true)
    {
        M.back() = xorBits(subkeys.first, M.back());
    }
    else
    {
        padBytes(block);
        M.push_back(xorBits(subkeys.second, block));
    }

    std::vector<byte> C = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

    for (size_t i = 0; i < M.size(); i++)
    {
        C = this->cipher.EncryptECB(xorBits(C, M.at(i)), this->key);
    }

    return C;
}