//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract FallBackExample {
    uint256 public result;

    receive() external payable {    //special functions
        result = 1;
    }

    fallback() external payable{    //special functions
        result = 2;
    }
}

/* Las dos se utilizan en casos distintos

Explainer from: https://solidity-by-example.org/fallback/
    
    Ether is sent to contract

          is msg.data empty?
              /   \ 
             yes  no
             /     \
        receive()?  fallback() 
         /   \ 
       yes   no
      /        \
  receive()  fallback()

*/
