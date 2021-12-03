# Blockchain Project python testing file
# used for testing on localhost Ganache blockchain
# imports
import numpy as np
import json
from web3 import Web3
import time

# web3 operations
ganache_url = "HTTP://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))
tfalse = web3.isConnected()
print("ganache connected:", tfalse)

# Basic web3 for Testing
block = web3.eth.getBlock('latest')
accounts = web3.eth.accounts # get all accounts for localhost

#contract jsons
arbiterAbi = json.loads('[ { "inputs": [], "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "address", "name": "newAddress", "type": "address" } ], "name": "ContractCreated", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "_timestamp", "type": "uint256" } ], "name": "NewOwnership", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "_timestamp", "type": "uint256" } ], "name": "TransactionCreated", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "_amount", "type": "uint256" }, { "indexed": false, "internalType": "bool", "name": "success", "type": "bool" } ], "name": "TransactionFunded", "type": "event" }, { "stateMutability": "payable", "type": "fallback" }, { "inputs": [ { "internalType": "address payable", "name": "_seller", "type": "address" }, { "internalType": "string", "name": "_bookTitle", "type": "string" }, { "internalType": "bool", "name": "ePfd", "type": "bool" }, { "internalType": "string", "name": "_hash", "type": "string" }, { "internalType": "uint256", "name": "_price", "type": "uint256" } ], "name": "addBook", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_id", "type": "uint256" }, { "internalType": "address", "name": "_buyer", "type": "address" } ], "name": "createTxn", "outputs": [ { "internalType": "bool", "name": "", "type": "bool" } ], "stateMutability": "payable", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_id", "type": "uint256" } ], "name": "fundTxn", "outputs": [], "stateMutability": "payable", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_id", "type": "uint256" } ], "name": "getBook", "outputs": [ { "internalType": "address payable", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getCount", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_id", "type": "uint256" } ], "name": "removeBook", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_id", "type": "uint256" } ], "name": "validateTxn", "outputs": [], "stateMutability": "payable", "type": "function" }, { "stateMutability": "payable", "type": "receive" } ]')
bookAbi = json.loads('[ { "inputs": [ { "internalType": "address payable", "name": "_arbiter", "type": "address" }, { "internalType": "address payable", "name": "_seller", "type": "address" }, { "internalType": "string", "name": "_bookTitle", "type": "string" }, { "internalType": "bool", "name": "ePfd", "type": "bool" }, { "internalType": "string", "name": "_hash", "type": "string" }, { "internalType": "uint256", "name": "_price", "type": "uint256" } ], "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "_amount", "type": "uint256" } ], "name": "BuyerRefunded", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "_timestamp", "type": "uint256" } ], "name": "ContractNull", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "_amount", "type": "uint256" } ], "name": "FundingReceived", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "_amount", "type": "uint256" } ], "name": "SellerPaid", "type": "event" }, { "stateMutability": "payable", "type": "fallback" }, { "inputs": [], "name": "amountInEth", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "balance", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "checkTime", "outputs": [ { "internalType": "bool", "name": "", "type": "bool" } ], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_amount", "type": "uint256" } ], "name": "convertAmount", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "pure", "type": "function" }, { "inputs": [], "name": "end_time", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "fund", "outputs": [], "stateMutability": "payable", "type": "function" }, { "inputs": [], "name": "getHash", "outputs": [ { "internalType": "string", "name": "", "type": "string" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getPhysical", "outputs": [ { "internalType": "bool", "name": "", "type": "bool" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getPrice", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getSeller", "outputs": [ { "internalType": "address", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getTitle", "outputs": [ { "internalType": "string", "name": "", "type": "string" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getbuyer", "outputs": [ { "internalType": "address", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "kill", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_amount", "type": "uint256" } ], "name": "payoutToSeller", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "refundBuyer", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "address payable", "name": "_buyer", "type": "address" } ], "name": "setBuyer", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "string", "name": "_hash", "type": "string" } ], "name": "setHash", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "bool", "name": "_phys", "type": "bool" } ], "name": "setPhysical", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_amountInWei", "type": "uint256" } ], "name": "setPrice", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "address payable", "name": "_seller", "type": "address" } ], "name": "setSeller", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "string", "name": "_title", "type": "string" } ], "name": "setTitle", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "validate", "outputs": [], "stateMutability": "payable", "type": "function" }, { "stateMutability": "payable", "type": "receive" } ]')

#contract address
arbiterAddr = "0x4B253f5519486A3e7A4E234F70dC79B0dAbfD64b"

# get arbiter instance
contract = web3.eth.contract(address=arbiterAddr, abi=arbiterAbi)

# define accounts and keys
keys[0] = "b81c1b9657c74767f3be43dc55873f71c48493fa9d059d9712537905937bb84b"
keys[1] = "bc68cb89e0c112048f1e938ed6321e2a31c7a38206fb1d65e0a9c6cea20ade50"
keys[2] = "d7d4b2c84516fa8b56898d324cf987c77462cffc16fc0fb65d4b546471e8096a"
keys[3] = "9110ae22b685a32ffc5c04a72e2933e2207460f29f53fbc9c40303a39e6b43eb"
keys[4] = "ce0352454ab2c1594357b932dacd9d9f7d172399ad4053c3470e42534f261af1"
keys[5] = "b2fd25852c33bb114a5434cb14ee53318d626ede93e485cecd2631793b5795df"
keys[6] = "8534f8488ca3c54229569a2d8c6749759d57686dddde45d2350170954f313118"
keys[7] = "14cd87ecf0bd5c251717ac808929921196e9b231bd4952c383f6a782bb1e43e5"
keys[8] = "156160f0431327a3c796d7fb83cb3241802ad15bb103eb8a677ad2d476bb149d"
keys[9] = "52819132b54ee8b070e46956b64abb7c57c801ff8418d4762f6a5cb51c7ab0d2"

# define nonces
nonce = []

for i in range(0,10):
    nonce[i] = web3.eth.getTransactionCount(accounts[i])


################################
###### BOOK DECLARATIONS #######
# Necessary Set for later testing declarations
# book = {title :, seller :, pfd :, _hash :, price :}
books = []
books[0] = 'Atishas Lamp'
books[1] = 'The Book of Trees'
books[2] = 'The Book of Spiders'
books[3] = 'The Book of Life'
books[4] = 'Aesops Fables'
books[5] = 'Avatar: The Last Airbender'
books[6] = 'Guniess Book of World Records'
books[7] = 'The Book of the Dead'
books[8] = 'The Babadook'
books[9] = 'The Tibetan book of the Dead'
books[10] = 'The Dead Sea Scrolls'
books[11] = 'The Last Olympian'
books[12] = 'The Sea of Monsters'
books[13] = 'The Call of Chthulu'
books[14] = 'House of Leaves'
books[15] = '50 Shades of Python'

################################

# define transaction fxns
# modelled on the send_tx function from CSCE 4575 homework 4
def add_book(_id, account, private_key, contract, book):
    # get book from contract

    nonce = web3.eth.getTransactionCount(account)  # get account of seller for nonce

    # create transaction for book Escrow contract
    tx_store = contract.functions.addBook(
        # book tuple stuff here
    ).buildTransaction({
        'gas': 2000000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': account,  # account of buyer
        'nonce': nonce
    })

    # sign and hash transaction
    signed_txn = web3.eth.account.signTransaction(tx_store, private_key)
    start_time = time.time()
    tx_hash = web3.eth.sendRawTransaction(signed_txn.rawTransaction)
    tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)

    end_time = time.time()
    print("time taken for transaction:", end_time - start_time)
    print("gas used for this transaction:", tx_receipt.gasUsed)
    print("the stored number is", contract.functions.retrieve().call())

def remove_book():
    # remove book from contract
    pass

def send_create_tx(_id, account, private_key, contract):
    # note: requires an active list of books to use

    # get book from contract
    bookAddr = contract.functions.getBook(_id).call()
    book = web3.eth.contract(address=bookAddr, abi=bookAbi)

    seller = book.functions.getSeller().call()
    nonce = web3.eth.getTransactionCount(seller) # get account of seller for nonce

    # create transaction for book Escrow contract
    tx_store = contract.functions.createTxn(
        _id, account
    ).buildTransaction({
        'gas': 2000000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': account, # account of buyer
        'nonce': nonce
    })

    # sign and hash transaction
    signed_txn = web3.eth.account.signTransaction(tx_store, private_key)
    start_time = time.time()
    tx_hash = web3.eth.sendRawTransaction(signed_txn.rawTransaction)
    tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)

    end_time = time.time()
    print("time taken for transaction:", end_time - start_time)
    print("gas used for this transaction:", tx_receipt.gasUsed)
    print("the stored number is", contract.functions.retrieve().call())


def send_fund_tx(_id, account, private_key, contract):
    # note: requires an active list of books to use

    # get book from contract
    bookAddr = contract.functions.getBook(_id).call()
    book = web3.eth.contract(address=bookAddr, abi=bookAbi)

    seller = book.functions.getSeller().call()
    nonce = web3.eth.getTransactionCount(
        seller)  # get account of seller for nonce

    # create transaction for book Escrow contract
    tx_store = contract.functions.createTxn(
        _id
    ).buildTransaction({
        'gas': 2000000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': account,  # account of buyer
        'nonce': nonce
    })

    # sign and hash transaction
    signed_txn = web3.eth.account.signTransaction(tx_store, private_key)
    start_time = time.time()
    tx_hash = web3.eth.sendRawTransaction(signed_txn.rawTransaction)
    tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)

    end_time = time.time()
    print("time taken for transaction:", end_time - start_time)
    print("gas used for this transaction:", tx_receipt.gasUsed)
    print("the stored number is", contract.functions.retrieve().call())





