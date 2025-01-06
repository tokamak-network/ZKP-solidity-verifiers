// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ITverifier} from "./interface/ITverifier.sol";

/* solhint-disable max-line-length */
/// @author Project Ooo team
/// @dev It uses a custom memory layout inside the inline assembly block. Each reserved memory cell is declared in the
/// constants below.
/// @dev For a better understanding of the verifier algorithm please refer to the following paper:
/// * Original Tokamak zkEVM Paper: https://eprint.iacr.org/2024/507.pdf
/// The notation used in the code is the same as in the papers.
/* solhint-enable max-line-length */
contract TVerifier is ITverifier {

    /*//////////////////////////////////////////////////////////////
                                  Public Inputs
    //////////////////////////////////////////////////////////////*/

    // preprocessed commitments
    uint256 internal constant PUBLIC_INPUT_PREPROCESSED_COM_S0_X_SLOT = 0x200 + 0x000;
    uint256 internal constant PUBLIC_INPUT_PREPROCESSED_COM_S0_Y_SLOT = 0x200 + 0x020;
    uint256 internal constant PUBLIC_INPUT_PREPROCESSED_COM_S1_X_SLOT = 0x200 + 0x040;
    uint256 internal constant PUBLIC_INPUT_PREPROCESSED_COM_S1_Y_SLOT = 0x200 + 0x060;

    // permutation polynomials
    uint256 internal constant PUBLIC_INPUT_PERMUTATION_POLY_S2_X_SLOT = 0x200 + 0x080;
    uint256 internal constant PUBLIC_INPUT_PERMUTATION_POLY_S2_Y_SLOT = 0x200 + 0x0a0;
    uint256 internal constant PUBLIC_INPUT_PERMUTATION_POLY_S2_Z_SLOT = 0x200 + 0x0c0;
    uint256 internal constant PUBLIC_INPUT_PERMUTATION_POLY_S3_X_SLOT = 0x200 + 0x0e0;
    uint256 internal constant PUBLIC_INPUT_PERMUTATION_POLY_S3_Y_SLOT = 0x200 + 0x100;
    uint256 internal constant PUBLIC_INPUT_PERMUTATION_POLY_S3_Z_SLOT = 0x200 + 0x120;
    uint256 internal constant PUBLIC_INPUT_A_IN_SLOT = 0x200 + 0x140;
    uint256 internal constant PUBLIC_INPUT_A_OUT_SLOT = 0x200 + 0x160;

    /*//////////////////////////////////////////////////////////////
                                  Proof
    //////////////////////////////////////////////////////////////*/

    // OPEN_0
    uint256 internal constant PROOF_OPENING_EVAL_U_X_SLOT = 0x200 + 0x180;
    uint256 internal constant PROOF_OPENING_EVAL_U_Y_SLOT = 0x200 + 0x1a0;
    uint256 internal constant PROOF_OPENING_EVAL_V_X0_SLOT = 0x200 + 0x1c0;
    uint256 internal constant PROOF_OPENING_EVAL_V_X1_SLOT = 0x200 + 0x1e0;
    uint256 internal constant PROOF_OPENING_EVAL_V_Y0_SLOT = 0x200 + 0x200;
    uint256 internal constant PROOF_OPENING_EVAL_V_Y1_SLOT = 0x200 + 0x220;
    uint256 internal constant PROOF_OPENING_EVAL_W_X_SLOT = 0x200 + 0x240;
    uint256 internal constant PROOF_OPENING_EVAL_W_Y_SLOT = 0x200 + 0x260;
    // selector polynomials
    uint256 internal constant PROOF_OPENING_EVAL_A_X_SLOT = 0x200 + 0x280;
    uint256 internal constant PROOF_OPENING_EVAL_A_Y_SLOT = 0x200 + 0x2a0;
    uint256 internal constant PROOF_OPENING_EVAL_B_X_SLOT = 0x200 + 0x2c0;
    uint256 internal constant PROOF_OPENING_EVAL_B_Y_SLOT = 0x200 + 0x2e0;
    uint256 internal constant PROOF_OPENING_EVAL_C_X_SLOT = 0x200 + 0x300;
    uint256 internal constant PROOF_OPENING_EVAL_C_Y_SLOT = 0x200 + 0x320;
    // recursion polynomial
    uint256 internal constant PROOF_RECURSION_POLY_X_SLOT = 0x200 + 0x340;
    uint256 internal constant PROOF_RECURSION_POLY_Y_SLOT = 0x200 + 0x360;
    // quotient polynomial
    uint256 internal constant PROOF_CONSTRAINT_POLY_X_SLOT = 0x200 + 0x380;
    uint256 internal constant PROOF_CONSTRAINT_POLY_Y_SLOT = 0x200 + 0x3a0;
    // points evaluations
    uint256 internal constant PROOF_R1_AT_ZETA_SLOT = 0x200 + 0x3c0;
    uint256 internal constant PROOF_R2_AT_ZETA_SLOT = 0x200 + 0x3e0;
    uint256 internal constant PROOF_B_AT_ZETA_SLOT = 0x200 + 0x400;
    // transcript components
    uint256 internal constant PROOF_PI0_X_SLOT = 0x200 + 0x420;
    uint256 internal constant PROOF_PI0_Y_SLOT = 0x200 + 0x440;
    uint256 internal constant PROOF_PI1_X_SLOT = 0x200 + 0x460;
    uint256 internal constant PROOF_PI1_Y_SLOT = 0x200 + 0x480;
    uint256 internal constant PROOF_PI2_X_SLOT = 0x200 + 0x4a0;
    uint256 internal constant PROOF_PI2_Y_SLOT = 0x200 + 0x4c0;
    uint256 internal constant PROOF_PI3_X_SLOT = 0x200 + 0x4e0;
    uint256 internal constant PROOF_PI3_Y_SLOT = 0x200 + 0x500;
    // permutation_polynomials_at_zeta; // Sσ1(zeta),Sσ2(zeta)
    uint256 internal constant PROOF_S2_AT_ZETA_SLOT = 0x200 + 0x520; // Sσ2(zeta0, zeta1)
    // L and K at zeta0 and zeta1
    uint256 internal constant PROOF_L_MINUS1_AT_ZETA0_SLOT = 0x200 + 0x540;
    uint256 internal constant PROOF_K_MINUS1_AT_ZETA1_SLOT = 0x200 + 0x560;
    uint256 internal constant PROOF_K_0_AT_ZETA0_SLOT = 0x200 + 0x580;

    /*//////////////////////////////////////////////////////////////
                 transcript slot (used for challenge computation)
    //////////////////////////////////////////////////////////////*/

    uint256 internal constant TRANSCRIPT_BEGIN_SLOT = 0x200 + 0x5a0;
    uint256 internal constant TRANSCRIPT_DST_BYTE_SLOT = 0x200 + 0x5c0;
    uint256 internal constant TRANSCRIPT_STATE_0_SLOT = 0x200 + 0x5e0;
    uint256 internal constant TRANSCRIPT_STATE_1_SLOT = 0x200 + 0x600;
    uint256 internal constant TRANSCRIPT_CHALLENGE_SLOT = 0x200 + 0x620;

    /*//////////////////////////////////////////////////////////////
                             Challenges
    //////////////////////////////////////////////////////////////*/

    uint256 internal constant CHALLENGE_TETA_0_SLOT = 0x200 + 0x640;
    uint256 internal constant CHALLENGE_TETA_1_SLOT = 0x200 + 0x660;
    uint256 internal constant CHALLENGE_TETA_2_SLOT = 0x200 + 0x680;
    uint256 internal constant CHALLENGE_KAPPA_0_SLOT = 0x200 + 0x6a0;
    uint256 internal constant CHALLENGE_KAPPA_1_SLOT = 0x200 + 0x6c0;
    uint256 internal constant CHALLENGE_ZETA_0_SLOT = 0x200 + 0x6e0;
    uint256 internal constant CHALLENGE_ZETA_1_SLOT = 0x200 + 0x700;

    /*//////////////////////////////////////////////////////////////
                       Intermediary verifier state
    //////////////////////////////////////////////////////////////*/

    uint256 internal constant INTERMEDIARY_POLY_P_X_SLOT = 0x200 + 0x720;
    uint256 internal constant INTERMEDIARY_POLY_P_Y_SLOT = 0x200 + 0x740;

    uint256 internal constant INTERMEDIARY_POLY_F_X_SLOT = 0x200 + 0x760;
    uint256 internal constant INTERMEDIARY_POLY_F_Y_SLOT = 0x200 + 0x780;

    uint256 internal constant INTERMEDIARY_G_AT_ZETA_EVAL_SLOT = 0x200 + 0x7a0;

    // [mu_{-1}]_1
    uint256 internal constant INTERMEDIARY_MU_MINUS_1_X_SLOT = 0x200 + 0x7c0;
    uint256 internal constant INTERMEDIARY_MU_MINUS_1_Y_SLOT = 0x200 + 0x7e0;

    /*//////////////////////////////////////////////////////////////
                             Pairing data
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                             Constants
    //////////////////////////////////////////////////////////////*/

    //uint256 internal constant COMMON_REFERENCE_STRING = 
    //uint256 internal constant PUBLIC_PARAMETER = 

    // Scalar field size
    uint256 internal constant Q_MOD = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
    uint256 internal constant R_MOD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    /// @dev flip of 0xe000000000000000000000000000000000000000000000000000000000000000;
    uint256 internal constant FR_MASK = 0x1fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    /*//////////////////////////////////////////////////////////////
                             subcircuit library vairables
    //////////////////////////////////////////////////////////////*/

    uint256 internal constant SUBCIRCUIT_LIBRARY_X = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_Y = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_Z = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_ALPHA_X = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_ALPHA_Y = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_BETA_X0 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_BETA_X1 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_BETA_Y0 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_BETA_Y1 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_GAMMA_X0 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_GAMMA_X1 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_GAMMA_Y0 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_GAMMA_Y1 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_DELTA_X0 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_DELTA_X1 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_DELTA_Y0 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_DELTA_Y1 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_ETA0 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_ETA1 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_MU = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_NU = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_PSI0 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_PSI1 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_PSI2 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_PSI3 = 0;
    uint256 internal constant SUBCIRCUIT_LIBRARY_KAPPA = 0;

    function verify(
        uint256[] calldata, // _publicInputs
        uint256[] calldata // _proof
    ) public view virtual returns (bool result, uint256 teta1, uint256 teta2, uint256 teta3, uint256 kappa0, uint256 kappa1, uint256 zeta0, uint256 zeta1) {
        
        assembly {

            /*//////////////////////////////////////////////////////////////
                                    Utils
            //////////////////////////////////////////////////////////////*/

            /// @dev Reverts execution with a provided revert reason.
            /// @param len The byte length of the error message string, which is expected to be no more than 32.
            /// @param reason The 1-word revert reason string, encoded in ASCII.
            function revertWithMessage(len, reason) {
                // "Error(string)" signature: bytes32(bytes4(keccak256("Error(string)")))
                mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                // Data offset
                mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
                // Length of revert string
                mstore(0x24, len)
                // Revert reason
                mstore(0x44, reason)
                // Revert
                revert(0x00, 0x64)
            }

            /// @dev Performs a point multiplication operation and stores the result in a given memory destination.
            function pointMulIntoDest(point, s, dest) {
                mstore(0x00, mload(point))
                mstore(0x20, mload(add(point, 0x20)))
                mstore(0x40, s)
                if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
                    revertWithMessage(30, "pointMulIntoDest: ecMul failed")
                }
            }

            /// @dev Performs a point addition operation and stores the result in a given memory destination.
            function pointAddIntoDest(p1, p2, dest) {
                mstore(0x00, mload(p1))
                mstore(0x20, mload(add(p1, 0x20)))
                mstore(0x40, mload(p2))
                mstore(0x60, mload(add(p2, 0x20)))
                if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
                    revertWithMessage(30, "pointAddIntoDest: ecAdd failed")
                }
            }

            /// @dev Performs a point multiplication operation and then adds the result to the destination point.
            function pointMulAndAddIntoDest(point, s, dest) {
                mstore(0x00, mload(point))
                mstore(0x20, mload(add(point, 0x20)))
                mstore(0x40, s)
                let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)

                mstore(0x40, mload(dest))
                mstore(0x60, mload(add(dest, 0x20)))
                success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))

                if iszero(success) {
                    revertWithMessage(22, "pointMulAndAddIntoDest")
                }
            }

            /// @dev Performs a point addition operation and updates the first point with the result.
            function pointAddAssign(p1, p2) {
                mstore(0x00, mload(p1))
                mstore(0x20, mload(add(p1, 0x20)))
                mstore(0x40, mload(p2))
                mstore(0x60, mload(add(p2, 0x20)))
                if iszero(staticcall(gas(), 6, 0x00, 0x80, p1, 0x40)) {
                    revertWithMessage(28, "pointAddAssign: ecAdd failed")
                }
            }

            /// @dev Performs a point subtraction operation and updates the first point with the result.
            function pointSubIntoDest(p1, p2, dest) {
                mstore(0x00, mload(p1))
                mstore(0x20, mload(add(p1, 0x20)))
                mstore(0x40, mload(p2))
                mstore(0x60, sub(Q_MOD, mload(add(p2, 0x20))))
                if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
                    revertWithMessage(28, "pointSubAssign: ecAdd failed")
                }
            }

            /*//////////////////////////////////////////////////////////////
                                    Transcript helpers
            //////////////////////////////////////////////////////////////*/

            /// @dev Updates the transcript state with a new challenge value.
            function updateTranscript(value) { 
                mstore8(TRANSCRIPT_DST_BYTE_SLOT, 0x00)
                mstore(TRANSCRIPT_CHALLENGE_SLOT, value)
                let newState0 := keccak256(TRANSCRIPT_BEGIN_SLOT, 0x64)
                mstore8(TRANSCRIPT_DST_BYTE_SLOT, 0x01)
                let newState1 := keccak256(TRANSCRIPT_BEGIN_SLOT, 0x64)
                mstore(TRANSCRIPT_STATE_1_SLOT, newState1)
                mstore(TRANSCRIPT_STATE_0_SLOT, newState0)
            }

            /// @dev Retrieves a transcript challenge.
            function getTranscriptChallenge(numberOfChallenge) -> challenge {
                mstore8(TRANSCRIPT_DST_BYTE_SLOT, 0x02)
                mstore(TRANSCRIPT_CHALLENGE_SLOT, shl(224, numberOfChallenge))
                challenge := and(keccak256(TRANSCRIPT_BEGIN_SLOT, 0x48), FR_MASK)
            }

            /*//////////////////////////////////////////////////////////////
                                        1. Load Proof
            //////////////////////////////////////////////////////////////*/

            /// @dev This function loads a zk-SNARK proof, ensures it's properly formatted, and stores it in memory.
            /// It ensures the number of inputs and the elliptic curve point's validity.
            /// Note: It does NOT reject inputs that exceed these module sizes, but rather wraps them within the
            /// module bounds.

            function loadProof() {
                // 1. Load public inputs
                let offset := calldataload(0x04)
                let publicInputLengthInWords := calldataload(add(offset, 0x04)) // we add 0x04 to skip the function selector
                let isValid := eq(publicInputLengthInWords, 12) // (We expect 12 public inputs) 

                // Load each public input into its respective slot
                mstore(PUBLIC_INPUT_PREPROCESSED_COM_S0_X_SLOT, and(calldataload(add(offset, 0x24)), FR_MASK))
                mstore(PUBLIC_INPUT_PREPROCESSED_COM_S0_Y_SLOT, and(calldataload(add(offset, 0x44)), FR_MASK))
                mstore(PUBLIC_INPUT_PREPROCESSED_COM_S1_X_SLOT, and(calldataload(add(offset, 0x64)), FR_MASK))
                mstore(PUBLIC_INPUT_PREPROCESSED_COM_S1_Y_SLOT, and(calldataload(add(offset, 0x84)), FR_MASK))
                mstore(PUBLIC_INPUT_PERMUTATION_POLY_S2_X_SLOT, and(calldataload(add(offset, 0xa4)), FR_MASK))
                mstore(PUBLIC_INPUT_PERMUTATION_POLY_S2_Y_SLOT, and(calldataload(add(offset, 0xc4)), FR_MASK))
                mstore(PUBLIC_INPUT_PERMUTATION_POLY_S2_Z_SLOT, and(calldataload(add(offset, 0xe4)), FR_MASK))
                mstore(PUBLIC_INPUT_PERMUTATION_POLY_S3_X_SLOT, and(calldataload(add(offset, 0x104)), FR_MASK))
                mstore(PUBLIC_INPUT_PERMUTATION_POLY_S3_Y_SLOT, and(calldataload(add(offset, 0x124)), FR_MASK))
                mstore(PUBLIC_INPUT_PERMUTATION_POLY_S3_Z_SLOT, and(calldataload(add(offset, 0x144)), FR_MASK))
                mstore(PUBLIC_INPUT_A_IN_SLOT, and(calldataload(add(offset, 0x164)), FR_MASK))
                mstore(PUBLIC_INPUT_A_OUT_SLOT, and(calldataload(add(offset, 0x184)), FR_MASK))

                // 2. Load the proof 
                offset := calldataload(0x24)
                let proofLengthInWords := calldataload(add(offset, 0x04))
                isValid := and(eq(proofLengthInWords, 32), isValid)

                // PROOF_OPENING_EVAL_U
                {
                    let x := mod(calldataload(add(offset, 0x24)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x44)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid) // we verify the point belongs to the BN128 curve
                    mstore(PROOF_OPENING_EVAL_U_X_SLOT, x)
                    mstore(PROOF_OPENING_EVAL_U_Y_SLOT, y)
                }
                // PROOF_OPENING_EVAL_V
                {
                    // Load x0, x1, y0, y1 from calldata
                    let x0 := mod(calldataload(add(offset, 0x64)), Q_MOD)
                    let x1 := mod(calldataload(add(offset, 0x84)), Q_MOD)
                    let y0 := mod(calldataload(add(offset, 0xa4)), Q_MOD)
                    let y1 := mod(calldataload(add(offset, 0xc4)), Q_MOD)

                    // Store the coordinates
                    mstore(PROOF_OPENING_EVAL_V_X0_SLOT, x0)
                    mstore(PROOF_OPENING_EVAL_V_X1_SLOT, x1)
                    mstore(PROOF_OPENING_EVAL_V_Y0_SLOT, y0)
                    mstore(PROOF_OPENING_EVAL_V_Y1_SLOT, y1)
                }
                // PROOF_OPENING_EVAL_W
                {
                    let x := mod(calldataload(add(offset, 0xe4)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x104)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_OPENING_EVAL_W_X_SLOT, x)
                    mstore(PROOF_OPENING_EVAL_W_Y_SLOT, y)
                }

                // PROOF_OPENING_EVAL_A
                {
                    let x := mod(calldataload(add(offset, 0x124)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x144)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_OPENING_EVAL_W_X_SLOT, x)
                    mstore(PROOF_OPENING_EVAL_W_Y_SLOT, y)
                }

                // PROOF_OPENING_EVAL_B
                {
                    let x := mod(calldataload(add(offset, 0x164)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x184)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_OPENING_EVAL_W_X_SLOT, x)
                    mstore(PROOF_OPENING_EVAL_W_Y_SLOT, y)
                }

                // PROOF_OPENING_EVAL_C
                {
                    let x := mod(calldataload(add(offset, 0x1a4)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x1c4)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_OPENING_EVAL_W_X_SLOT, x)
                    mstore(PROOF_OPENING_EVAL_W_Y_SLOT, y)
                }

                // PROOF_RECURSION_POLY
                {
                    let x := mod(calldataload(add(offset, 0x1e4)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x204)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_RECURSION_POLY_X_SLOT, x)
                    mstore(PROOF_RECURSION_POLY_Y_SLOT, y)
                }

                // PROOF_CONSTRAINT_POLY
                {
                    let x := mod(calldataload(add(offset, 0x224)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x244)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_CONSTRAINT_POLY_X_SLOT, x)
                    mstore(PROOF_CONSTRAINT_POLY_X_SLOT, y)
                }

                mstore(PROOF_R1_AT_ZETA_SLOT, mod(calldataload(add(offset, 0x264)), R_MOD))
                mstore(PROOF_R2_AT_ZETA_SLOT, mod(calldataload(add(offset, 0x284)), R_MOD))
                mstore(PROOF_B_AT_ZETA_SLOT, mod(calldataload(add(offset, 0x2a4)), R_MOD))

                // PROOF_PI0
                {
                    let x := mod(calldataload(add(offset, 0x2c4)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x2e4)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_PI0_X_SLOT, x)
                    mstore(PROOF_PI0_Y_SLOT, y)
                }

                // PROOF_PI1
                {
                    let x := mod(calldataload(add(offset, 0x304)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x324)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_PI1_X_SLOT, x)
                    mstore(PROOF_PI1_Y_SLOT, y)
                }

                // PROOF_PI2
                {
                    let x := mod(calldataload(add(offset, 0x344)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x364)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_PI2_X_SLOT, x)
                    mstore(PROOF_PI2_Y_SLOT, y)
                }

                // PROOF_PI3
                {
                    let x := mod(calldataload(add(offset, 0x384)), Q_MOD)
                    let y := mod(calldataload(add(offset, 0x3a4)), Q_MOD)
                    let xx := mulmod(x, x, Q_MOD)
                    isValid := and(eq(mulmod(y, y, Q_MOD), addmod(mulmod(x, xx, Q_MOD), 3, Q_MOD)), isValid)
                    mstore(PROOF_PI3_X_SLOT, x)
                    mstore(PROOF_PI3_Y_SLOT, y)
                }

                // 
                mstore(PROOF_S2_AT_ZETA_SLOT, mod(calldataload(add(offset, 0x3c4)), R_MOD))
                mstore(PROOF_L_MINUS1_AT_ZETA0_SLOT, mod(calldataload(add(offset, 0x3e4)), R_MOD))
                mstore(PROOF_K_MINUS1_AT_ZETA1_SLOT, mod(calldataload(add(offset, 0x404)), R_MOD))
                

                // Revert if a proof/public input is not valid
                if iszero(isValid) {
                    revertWithMessage(27, "loadProof: Proof is invalid")
                }

            }

            /*//////////////////////////////////////////////////////////////
                                    2. Transcript initialization
            //////////////////////////////////////////////////////////////*/

            /// @notice Recomputes all challenges
            /// @dev The process is the following:
            /// Commit:   [U], [V], [W], [A], [B], [C]
            /// Get:      teta1, teta2 & teta3

            function initializeTranscript() {
                updateTranscript(mload(PROOF_OPENING_EVAL_U_X_SLOT))
                updateTranscript(mload(PROOF_OPENING_EVAL_U_Y_SLOT))

                mstore(CHALLENGE_TETA_0_SLOT, getTranscriptChallenge(0))

                updateTranscript(mload(PROOF_OPENING_EVAL_V_X0_SLOT))
                updateTranscript(mload(PROOF_OPENING_EVAL_V_X1_SLOT))
                updateTranscript(mload(PROOF_OPENING_EVAL_V_Y0_SLOT))
                updateTranscript(mload(PROOF_OPENING_EVAL_V_Y1_SLOT))
                updateTranscript(mload(PROOF_OPENING_EVAL_W_X_SLOT))
                updateTranscript(mload(PROOF_OPENING_EVAL_W_Y_SLOT))

                mstore(CHALLENGE_TETA_1_SLOT, getTranscriptChallenge(1))

                updateTranscript(mload(PROOF_OPENING_EVAL_B_X_SLOT))
                updateTranscript(mload(PROOF_OPENING_EVAL_B_Y_SLOT))

                mstore(CHALLENGE_TETA_2_SLOT, getTranscriptChallenge(2))

                updateTranscript(mload(PROOF_RECURSION_POLY_X_SLOT))
                updateTranscript(mload(PROOF_RECURSION_POLY_Y_SLOT))

                mstore(CHALLENGE_KAPPA_0_SLOT, getTranscriptChallenge(3))

                updateTranscript(mload(PROOF_CONSTRAINT_POLY_X_SLOT))
                mstore(CHALLENGE_ZETA_0_SLOT, getTranscriptChallenge(4))

                updateTranscript(mload(PROOF_CONSTRAINT_POLY_Y_SLOT))
                mstore(CHALLENGE_ZETA_1_SLOT, getTranscriptChallenge(5))

                updateTranscript(mload(PROOF_R1_AT_ZETA_SLOT))
                updateTranscript(mload(PROOF_R2_AT_ZETA_SLOT))
                updateTranscript(mload(PROOF_B_AT_ZETA_SLOT))

                mstore(CHALLENGE_KAPPA_1_SLOT, getTranscriptChallenge(6))

            }

            /*//////////////////////////////////////////////////////////////
                        4. Computing the intermediary polynomial P
            //////////////////////////////////////////////////////////////*/

            /// @dev [P]_1 = L_-1(zeta0) * K_-1(zeta1) * ([R]_1 - [mu^{-1}]_1)
            ///       + kappa0 * (zeta1 - 1) * (G * [R]_1 - R1YZ * [F]_1)
            ///       + kappa0^2 * K_0(zeta1) * (G * [R]_1 - R2YZ * [F]_1)
            ///       + kappa1 * ([B]_1 - BYZ * [mu^{-1}]_1)
            ///
            ///  where
            ///      
            ///       G = BYZ + teta0 * zeta0 + teta1 * s2(zeta1, zeta2) + teta2
            ///      [F]_1 = [B]_1 + teta0 * [S0]_1 + teta1 * [S1]_1 + teta2 * [mu^{-1}]_1

            function computeConstraintFinalPolynomial() {
                /// compute G which does not involve any EC addition/multiplication
                let byz := mload(PROOF_B_AT_ZETA_SLOT) // B(zeta0, zeta1) 
                let t0 := mload(CHALLENGE_TETA_0_SLOT) // teta0
                let t1 := mload(CHALLENGE_TETA_1_SLOT) // teta1
                let t2 := mload(CHALLENGE_TETA_2_SLOT) // teta2
                let z0 := mload(CHALLENGE_ZETA_0_SLOT) // zeta0
                let z1 := mload(CHALLENGE_ZETA_1_SLOT) // zeta1
                let sigmaS2 := mload(PROOF_S2_AT_ZETA_SLOT) // s2(zeta1, zeta2)
                let g := addmod(byz, mulmod(t0,z0, R_MOD), R_MOD)
                g := addmod(g, mulmod(t1,sigmaS2, R_MOD), R_MOD)
                g := addmod(g, t2, R_MOD) // G = BYZ + teta0 * zeta0 + teta1 * s2(zeta1, zeta2) + teta2
                mstore(INTERMEDIARY_G_AT_ZETA_EVAL_SLOT, g)

                /// compute [F]_1
                // 1. compute teta0 * [S0]_1
                pointMulIntoDest(PUBLIC_INPUT_PREPROCESSED_COM_S0_X_SLOT, t0, INTERMEDIARY_POLY_F_X_SLOT)
                // 2. compute [B]_1 + teta0 * [S0]_1
                pointAddAssign(INTERMEDIARY_POLY_F_X_SLOT, PROOF_OPENING_EVAL_B_X_SLOT)
                // 3. compute [B]_1 + teta0 * [S0]_1 + teta1 * [S1]_1
                pointMulAndAddIntoDest(PUBLIC_INPUT_PREPROCESSED_COM_S1_X_SLOT, t1, INTERMEDIARY_POLY_F_X_SLOT)
                // 4. [F]_1 = [B]_1 + teta0 * [S0]_1 + teta1 * [S1]_1 + teta2 * [mu^{-1}]_1
                pointMulAndAddIntoDest(INTERMEDIARY_MU_MINUS_1_X_SLOT, t2, INTERMEDIARY_POLY_F_X_SLOT)

                /// compute [P]_1
                // 1. compute L_-1(zeta0) * K_-1(zeta1) * ([R]_1 - [mu^{-1}]_1)
                let firstPartOfP
                pointSubIntoDest(PROOF_RECURSION_POLY_X_SLOT, INTERMEDIARY_MU_MINUS_1_X_SLOT, firstPartOfP)
                let factorMultiplier1 := mulmod(mload(PROOF_L_MINUS1_AT_ZETA0_SLOT), mload(PROOF_K_MINUS1_AT_ZETA1_SLOT), R_MOD)
                pointMulIntoDest(firstPartOfP, factorMultiplier1, INTERMEDIARY_POLY_P_X_SLOT)
                
                // 2. compute kappa0 * (zeta1 - 1) * (G * [R]_1 - R1YZ * [F]_1) and add it to the final P polynomial
                let factorMultiplier2 := mulmod(sub(z1, 1), mload(CHALLENGE_KAPPA_0_SLOT), R_MOD)
                let gTimesR 
                pointMulIntoDest(PROOF_RECURSION_POLY_X_SLOT, g, gTimesR)
                let r1TimesF
                pointMulIntoDest(INTERMEDIARY_POLY_F_X_SLOT, PROOF_R1_AT_ZETA_SLOT, r1TimesF)
                let gTimesRMinusrTimesF
                pointSubIntoDest(gTimesR,r1TimesF,gTimesRMinusrTimesF)
                let secondPartOfP
                pointMulIntoDest(gTimesRMinusrTimesF, factorMultiplier2, secondPartOfP)
                pointAddIntoDest(INTERMEDIARY_POLY_P_X_SLOT,secondPartOfP,INTERMEDIARY_POLY_P_X_SLOT)
                
                // 4. compute kappa0^2 * K_0(zeta1) * (G * [R]_1 - R2YZ * [F]_1) and add it to the final P polynomial
                let factorMultiplier3
                {
                    factorMultiplier3 := mulmod(mload(CHALLENGE_KAPPA_0_SLOT), mload(CHALLENGE_KAPPA_0_SLOT), R_MOD) // kappa0^2
                    factorMultiplier3 := mulmod(factorMultiplier3, mload(PROOF_K_0_AT_ZETA0_SLOT), R_MOD) // kappa0^2 * K_0(zeta1)
                }
                let thirdPartOfP
                pointMulIntoDest(INTERMEDIARY_POLY_F_X_SLOT, PROOF_R2_AT_ZETA_SLOT, thirdPartOfP)
                pointSubIntoDest(gTimesR, thirdPartOfP, thirdPartOfP)
                pointMulIntoDest(thirdPartOfP, factorMultiplier3, thirdPartOfP)
                pointAddIntoDest(INTERMEDIARY_POLY_P_X_SLOT, thirdPartOfP, INTERMEDIARY_POLY_P_X_SLOT)

                //5. compute kappa1 * ([B]_1 - BYZ * [mu^{-1}]_1) and add it to the final P polynomial
                let fourthPartOfP
                pointMulIntoDest(INTERMEDIARY_MU_MINUS_1_X_SLOT, PROOF_B_AT_ZETA_SLOT, fourthPartOfP)
                pointSubIntoDest(PROOF_OPENING_EVAL_B_X_SLOT, fourthPartOfP, fourthPartOfP)
                pointMulIntoDest(fourthPartOfP, mload(CHALLENGE_KAPPA_1_SLOT), fourthPartOfP)
                pointAddIntoDest(INTERMEDIARY_POLY_P_X_SLOT, fourthPartOfP, INTERMEDIARY_POLY_P_X_SLOT)
            }

            /*//////////////////////////////////////////////////////////////
                            5. copy constraint pairing
            //////////////////////////////////////////////////////////////*/

            function copyConstraintPairing() {
                
            } 

            /*//////////////////////////////////////////////////////////////
                            6. Arithmetic constraint pairing
            //////////////////////////////////////////////////////////////*/


            /*//////////////////////////////////////////////////////////////
                            7. inner product pairing
            //////////////////////////////////////////////////////////////*/


            /*//////////////////////////////////////////////////////////////
                                    Verification
            //////////////////////////////////////////////////////////////*/

            // Step 1: Load the proof and check the correctness of its parts
            loadProof()

            // Step 2: Recompute all the challenges with the transcript
            initializeTranscript()

            teta1 := mload(CHALLENGE_TETA_0_SLOT)
            teta2 := mload(CHALLENGE_TETA_1_SLOT)
            teta3 := mload(CHALLENGE_TETA_2_SLOT)
            kappa0 := mload(CHALLENGE_KAPPA_0_SLOT)
            kappa1 := mload(CHALLENGE_KAPPA_1_SLOT)
            zeta0 := mload(CHALLENGE_ZETA_0_SLOT)
            zeta1 := mload(CHALLENGE_ZETA_1_SLOT)
            result := 1
            mstore(0, true)
        }

    }
}