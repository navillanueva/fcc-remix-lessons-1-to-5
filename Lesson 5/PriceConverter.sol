/*
    ¿WHAT IS A LIBRARY?

        Libraries are similar to contracts, but you can't declare any state variable and you can't send ether.
        A library is embedded into the contract if all library functions are internal.
        Otherwise the library must be deployed and then linked before the contract is deployed.

        Esta librería se ha utilizado para optimizar el contrato de FundeMe.sol
        Implementandola, hemos traspasado las funciones de getPrice(), getVersion() y getConversionRate() 
        Por lo tanto tambien hay que importar la interfaz de nodos de chainlink

*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; 

library PriceConverter {

    /*
        Es una función que va a interactuar con otro contrato fuera de nuestro codigo
        este contrato va a ser el que almacena las funciones que se utilizan para obtener
        datos del nodo de chainlink. Por lo tanto, vamos a necesitar:
            -address
            -ABI (Application Binary Interface)
        del contrato con el que se interactua.
    
    */
    function getPrice()internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e); //address del contrato lo relacionamos a una variable local
        
        //hay que alocar una variable para todas las que devuelve la funcion de lastestRoundDate dentro de la interfaz creada por chainlink

        //(uint80 roundId, int price, uint startedAt, uint time, uint80 answeredInRound) = priceFeed.latestRoundData(); 

        //Pero solo nos interesa el precio entonces podemos eliminar el resto para no cargar el codigo
        //ETH in terms of USD

        (,int256 price,,,) = priceFeed.latestRoundData(); 
        return uint256(price * 1e10);
    }

    function getVersion() internal view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount)internal view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; //always add and multiply before dividing
        return ethAmountInUsd;
    }


}