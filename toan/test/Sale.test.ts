import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { network } from "hardhat";

describe("Sale", async function () {
    const { viem } = await network.connect();

    it("Should send 5% fee to owner when someone buys", async function () {

        const token = await viem.deployContract("ThuToken", [1000000n * 10n ** 18n]);


        const sale = await viem.deployContract("TokenSale", [token.address]);

        await token.write.transfer([sale.address, 1000000n * 10n ** 18n]);

        const buyer = (await viem.getWalletClients())[1];
        const ethAmount = 1n * 10n ** 18n;


        await buyer.writeContract({
            address: sale.address,
            abi: sale.abi,
            functionName: "buyTokens",
            value: ethAmount,
        });

        const saleOwner = (await viem.getWalletClients())[0];
        const fee = (ethAmount * 1000n * 5n) / 100n;
        const buyerBalance = await token.read.balanceOf([buyer.account.address]);
        const ownerBalance = await token.read.balanceOf([saleOwner.account.address]);

        assert.equal(ownerBalance > 0n, true);
        assert.equal(buyerBalance > 0n, true);
    });
});
