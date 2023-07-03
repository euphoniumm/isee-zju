#pragma once

#include <utility>
#include "AES.hpp"
#include <iostream>

#define MSB_BYTE_MASK (0x80)
#define BLOCK_BYTES_LENGTH (16 * sizeof(byte))

class AesCmac
{
private:
	AES cipher;
	std::vector<byte> key;

	std::pair<std::vector<byte>, std::vector<byte>> generateSubkeys(void);
	std::vector<byte> xorBits(std::vector<byte> x, std::vector<byte> y);
	std::vector<byte> shiftBitsLeft(std::vector<byte> x, size_t n);
	void padBytes(std::vector<byte> &x);
public:
	explicit AesCmac(AES& cipher, std::vector<byte> key);
	std::vector<byte> generateCmac(std::vector<byte> message);
};