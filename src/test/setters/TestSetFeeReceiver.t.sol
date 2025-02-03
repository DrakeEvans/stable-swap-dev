// SPDX-License-Identifier: ISC
pragma solidity ^0.8.28;

import "../BaseTest.sol";

contract TestSetFeeReceiver is BaseTest {
    address payable public newFeeReceiver;

    function setUp() public {
        /// BACKGROUND:
        _defaultSetup();
        newFeeReceiver = labelAndDeal("newFeeReceiver");

        assertTrue({ err: "/// GIVEN: admin has ADMIN_ROLE", data: pair.hasRole(ADMIN_ROLE, adminAddress) });
    }

    function test_CanSetFeeReceiver() public {
        address _initialFeeReceiver = pair._getPointerToStorage().configStorage.feeReceiverAddress;

        /// WHEN: admin sets fee receiver to new address
        hoax(adminAddress);
        vm.expectEmit(true, false, false, true);
        emit SetFeeReceiver(newFeeReceiver);
        pair.setFeeReceiver(newFeeReceiver);

        assertTrue({
            err: "/// THEN: fee receiver should be updated",
            data: pair._getPointerToStorage().configStorage.feeReceiverAddress == newFeeReceiver
        });
    }

    function test_CanSetFeeReceiverToSameAddress() public {
        address _currentFeeReceiver = pair._getPointerToStorage().configStorage.feeReceiverAddress;

        /// WHEN: admin sets fee receiver to same address
        hoax(adminAddress);
        pair.setFeeReceiver(_currentFeeReceiver);

        assertTrue({
            err: "/// THEN: fee receiver should remain unchanged",
            data: pair._getPointerToStorage().configStorage.feeReceiverAddress == _currentFeeReceiver
        });
    }

    function test_CannotSetFeeReceiverIfNotAdmin() public {
        address _initialFeeReceiver = pair._getPointerToStorage().configStorage.feeReceiverAddress;

        /// WHEN: non-admin tries to set fee receiver
        vm.expectRevert(abi.encodeWithSelector(AgoraAccessControl.AddressIsNotRole.selector, ADMIN_ROLE));
        pair.setFeeReceiver(newFeeReceiver);

        assertTrue({
            err: "/// THEN: fee receiver should remain unchanged",
            data: pair._getPointerToStorage().configStorage.feeReceiverAddress == _initialFeeReceiver
        });
    }

    function test_CanSetFeeReceiverToZeroAddress() public {
        address _initialFeeReceiver = pair._getPointerToStorage().configStorage.feeReceiverAddress;

        /// WHEN: admin sets fee receiver to zero address
        hoax(adminAddress);
        pair.setFeeReceiver(address(0));

        assertTrue({
            err: "/// THEN: fee receiver should be set to zero address",
            data: pair._getPointerToStorage().configStorage.feeReceiverAddress == address(0)
        });
    }
}
