// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {VerifierV1} from "../../src/Tokamak-zkEVM/VerifierV1.sol";
import "forge-std/console.sol";

contract testTokamakVerifier is Test {
    VerifierV1 verifier;

    uint128[] public serializedProofPart1;
    uint256[] public serializedProofPart2;

    function setUp() public virtual {
        verifier = new VerifierV1();
        // proof

        serializedProofPart1.push(31827880280837800241567138048534752271); // s^{(0)}(x,y)_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // s^{(0)}(x,y)_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // s^{(1)}(x,y)_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // s^{(1)}(x,y)_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // s^{(2)}(x,y)_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // s^{(2)}(x,y)_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // U_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // U_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // V_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // V_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // W_X 
        serializedProofPart1.push(11568204302792691131076548377920244452); // W_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // O_mid_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // O_mid_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // O_prv_X 
        serializedProofPart1.push(11568204302792691131076548377920244452); // O_prv_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Q_{AX}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Q_{AX}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Q_{AY}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Q_{AY}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Q_{CX}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Q_{CX}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Q_{CY}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Q_{CY}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Π_{A,χ}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Π_{A,χ}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Π_{A,ζ}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Π_{A,ζ}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Π_{B,χ}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Π_{B,χ}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Π_{B,ζ}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Π_{B,ζ}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Π_{C,χ}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Π_{C,χ}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // Π_{C,ζ}_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // Π_{C,ζ}_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // B_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // B_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // R_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // R_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // M_ζ_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // M_ζ_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // M_χ_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // M_χ_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // N_ζ_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // N_ζ_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // N_χ_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // N_χ_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // O_pub_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // O_pub_Y
        serializedProofPart1.push(31827880280837800241567138048534752271); // A_X
        serializedProofPart1.push(11568204302792691131076548377920244452); // A_Y

        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // s^{(0)}(x,y)_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // s^{(0)}(x,y)_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // s^{(1)}(x,y)_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // s^{(1)}(x,y)_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // s^{(2)}(x,y)_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // s^{(2)}(x,y)_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // U_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // U_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // V_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // V_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // W_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // W_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // O_mid_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // O_mid_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // O_prv_X 
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // O_prv_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Q_{AX}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Q_{AX}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Q_{AY}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Q_{AY}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Q_{CX}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Q_{CX}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Q_{CY}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Q_{CY}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Π_{A,χ}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Π_{A,χ}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Π_{A,ζ}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Π_{A,ζ}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Π_{B,χ}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Π_{B,χ}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Π_{B,ζ}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Π_{B,ζ}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Π_{C,χ}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Π_{C,χ}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // Π_{C,ζ}_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // Π_{C,ζ}_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // B_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // B_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // R_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // R_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // M_ζ_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // M_ζ_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // M_χ_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // M_χ_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // N_ζ_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // N_ζ_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // N_χ_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // N_χ_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // O_pub_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // O_pub_Y
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // A_X
        serializedProofPart2.push(114417265404584670498511149331300188430316142484413708742216858159411894806497); // A_Y

        // evaluations
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // R1XY
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // R2XY
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // R3XY
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // VXY
        serializedProofPart2.push(88385725958748408079899006800036250932223001591707578097800747617502997169851); // A_PUB

    }

    function testVerifier() public view {
        // Call the verify function
        bytes32 result = verifier.verify(serializedProofPart1, serializedProofPart2);
        console.logBytes32(result);  
    }
}
