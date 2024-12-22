pragma solidity 0.8.26;

contract degreeVerifier {
    // Mapping to store student data with a unique code (bytes8) as the key and degree details (string) as the value
    mapping(bytes8 => string) private STDs; // code -> "Uni|Name|Reg|Date|Type|Field"
    
    // Mapping to store registered university codes (bytes4)
    mapping(bytes4 => bool) private UNIs; 

    // Array to keep track of the unique student codes (bytes8)
    bytes8[] private STDArray;

    // Constructor to initialize the contract with test data
    constructor() {
        // Registering university code for GIKI
        bytes4 uniCode = "GIKI";
        UNIs[uniCode] = true;

        // Adding test student details
        bytes8 testSTD = "TEST1234";
        STDs[testSTD] = "TEST FOUND";

        testSTD = "TEST1111";
        STDs[testSTD] = "TEST|Std|123|021224|BS|CS";

        // Storing test student code in the array
        STDArray.push("TEST1111");
    }

    // Function to retrieve the last student's details from the array
    function readLast() public view returns(string memory) {
        // Return the last student entry from the STDArray
        string memory data = string(abi.encodePacked(STDArray[STDArray.length - 1]));
        return data;
    }

    // Function to verify a degree by the student code
    function VerifyDegree(string memory code) public view returns (string memory) {
        // Convert the provided code to bytes8 and fetch the corresponding student details
        string memory data = STDs[bytes8(bytes(code))];
        if (bytes(data).length == 0) {
            return "NULL"; // Return NULL if the code does not exist
        }
        return data; // Return the student details if found
    }

    // Function to add a new degree to the system
    function AddDegree(
        string memory uniCodeString,
        string memory name,
        string memory regNo,
        string memory date,
        string memory degreeType,
        string memory field
    ) public returns (string memory) {
        // Ensure the university code length is exactly 4 characters
        if(bytes(uniCodeString).length != 4) {
            return "ERROR: Invalid University Code"; // Return error if the university code is invalid
        }

        // Convert university code string to bytes4
        bytes4 uniCode = bytes4(bytes(uniCodeString));

        // Check if the university is registered
        if (!UNIs[uniCode]) {
            return "ERROR: University is not registered"; // Return error if university is not registered
        }

        // Generate a unique student code for the new degree
        bytes8 uniqueCode = generateUniqueCode(uniCode);
        // Ensure the unique code does not already exist
        while (bytes(STDs[bytes8(uniqueCode)]).length != 0) {
            uniqueCode = generateUniqueCode(uniCode); // Generate a new unique code if the current one is already taken
        }

        // Store the degree details in the mapping with the unique student code
        STDs[uniqueCode] = string(abi.encodePacked(uniCode, "|", name, "|", regNo, "|", date, "|", degreeType, "|", field));
        
        // Add the new student code to the array
        STDArray.push(uniqueCode);

        // Return the generated unique student code
        return string(abi.encodePacked(uniqueCode));
    }

    // Function to check if a university is registered
    function isUniRegistered(bytes4 uniCode) public view returns (bool) {
        // Return true if the university is registered, false otherwise
        return UNIs[uniCode];
    }

    // Function to generate a unique student code using a hash and university code
    function generateUniqueCode(bytes4 uniCode) public view returns (bytes8) {
        // Generate a hash based on the current block's timestamp, random number, and the sender's address
        bytes32 hash = keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender));
        
        // Convert the hash into a unique 8-byte student code by appending the university code
        return bytes8(abi.encodePacked(uniCode, stdCode(hash)));
    }

    // Helper function to convert a hash to a 4-character alphanumeric code
    function stdCode(bytes32 hash) private pure returns (bytes4) {
        // Define the alphabet of characters that can be used in the code
        bytes memory alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        bytes4 result;

        // Loop through the hash and generate the 4-character code
        for (uint256 i = 0; i < 4; i++) {
            result |= bytes4(uint32(bytes4((alphabet[uint8(hash[i]) % alphabet.length])) >> (i*8)));
        }

        // Return the generated 4-character code
        return result;
    }
}
