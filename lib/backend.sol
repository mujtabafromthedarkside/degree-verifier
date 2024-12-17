pragma solidity 0.8.26;

contract degreeVerifier{
    // Store student data as a mapping from code to details
    mapping(bytes8 => string) private STDs; // code -> "Uni|Name|Reg|Date|Type|Field"
    mapping(bytes4 => bool) private UNIs;
    // string[] private keys;                  // to keep track of keys because map is not iterable

    constructor(){
        bytes4 uniCode = "GIKI";
        UNIs[uniCode] = true;

        bytes8 testSTD = "TEST1234";
        STDs[testSTD] = "TEST FOUND";

        testSTD = "TEST1111";
        STDs[testSTD] = "TEST|Std|123|021224|BS|CS";
    }

    // Verify a degree by code
    function VerifyDegree(string memory code) public view returns (string memory) {
        string memory data = STDs[bytes8(bytes(code))];
        if (bytes(data).length == 0) {
            return "NULL"; // Code not found
        }
        return data; // Return student details
    }

    // Add a degree to the system
    function AddDegree(
        string memory uniCodeString,
        string memory name,
        string memory regNo,
        string memory date,
        string memory degreeType,
        string memory field
    ) public returns (string memory) {
        if(bytes(uniCodeString).length != 4) {
            return "ERROR: Invalid University Code";
        }

        // Check if university exists

        bytes4 uniCode = bytes4(bytes(uniCodeString));
        if (!UNIs[uniCode]) {
            return "ERROR: University is not registered"; // University code not registered
        }

        // Generate a unique random code
        bytes8 uniqueCode = generateUniqueCode(uniCode);
        while (bytes(STDs[bytes8(uniqueCode)]).length != 0) {
            uniqueCode = generateUniqueCode(uniCode); // Ensure the code is unique
        }

        // Add degree details to STD
        STDs[uniqueCode] = string(abi.encodePacked(uniCode, "|", name, "|", regNo, "|", date, "|", degreeType, "|", field));

        return string(abi.encodePacked(uniqueCode)); // Return the generated code
    }

    function test_isUniRegistered(string memory uniCode) public view returns (string memory){
        require(bytes(uniCode).length == 4, "uniCode must be exactly 4 characters.");

        if(isUniRegistered(bytes4(bytes(uniCode)))) return "YES";
        else return "NO";
    }

    // Helper function to check if a university registration set exists
    function isUniRegistered(bytes4 uniCode) public view returns (bool) {
        // Check if any registration exists for this university code
        return UNIs[uniCode];
    }

    function test_generateUniqueCode(string memory uniCode) public view returns (string memory){
        require(bytes(uniCode).length == 4, "uniCode must be exactly 4 characters.");

        return string(abi.encodePacked(generateUniqueCode(bytes4(bytes(uniCode)))));
    }

    function generateUniqueCode(bytes4 uniCode) public view returns (bytes8) {
        // Generate a strong hash
        bytes32 hash = keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender));
        
        // Convert to a 4-character alphanumeric string
        return bytes8(abi.encodePacked(uniCode, stdCode(hash)));
    }

    function stdCode(bytes32 hash) private pure returns (bytes4) {
        bytes memory alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        bytes4 result;

        for (uint256 i = 0; i < 4; i++) {
            result |= bytes4(uint32(bytes4((alphabet[uint8(hash[i]) % alphabet.length])) >> (i*8)));
        }

        return result;
    }
}