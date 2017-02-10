pragma solidity ^0.4.9;

/**
* An asset is a blockchain representation of a physical item a person can let(rent out).
* This Asset will be created by an OwnerContract
*/
contract Asset{

    /**
    * Available (time units) for which an asset can be rented.
    */
    enum TimeUnit {
        HOUR,
        DAY,
        MONTH
    }

    /**
    * address of the owner contract.
    *   an owner contract can have multiple assets.
    */
    address _owner;

    /**
    *  address of the latest renter.
    *    0x0 if it hasn't been rented. 
    */
    address _currentRenter;

    /**
    * Description of the item.
    */
    //TODO: Should we limit this to a certain amount of characters?, maybe a bytes object. (and certain kind of characters?)
    string _description; 

    /**
    * ID to link a physical item to the blockchain.
    */
    //TODO: how large?
    uint _id; 

    /**
    * The price of the asset per time unit. E.g. 50 ether per day.
    */
    uint _pricePerTimeUnit;

    /**
    * time unit for which this asset can be rented.
    */
    TimeUnit _timeUnit;

    /**
    * This constructor will create an asset.
    * it should be called by an OwnerContract to correctly work with the ShareEverything application.
    */
    //TODO: can we limit the constructor to be only called by a certain contract type?
    function Asset(uint id, string description, uint pricePerTimeUnit, TimeUnit timeUnit){ 
        _owner = msg.sender;
        _id = id;
        _description = description;
        _pricePerTimeUnit = pricePerTimeUnit;
        _timeUnit = timeUnit;
    }

    /**
    * remove the contract. Can only be executed by the owner.
    * this will set all values to 0 and make it impossible to interact with.
    * money will be send to the owner.
    * can only be called if the asset is notRented.
    */
    function remove() onlyOwner notRented {
        selfdestruct(_owner);
    }

    function getDescription() constant returns (string){
        return _description;
    }

    function setDescription(string description) onlyOwner{
        _description = description;
    }

    function getID() constant returns (uint){
        return _id;
    }

    function setID(uint id) onlyOwner{
        _id = id;
    }

    function getPricePerTimeUnit() constant returns (uint){
        return _pricePerTimeUnit;
    }

    function setPricePerTimeUnit(uint price) onlyOwner{
        _pricePerTimeUnit = price;
    }

    function getTimeUnit() constant returns (TimeUnit){
        return _timeUnit;
    }

    function setTimeUnit(TimeUnit timeUnit){
        _timeUnit = timeUnit;
    }

    modifier onlyOwner {
        if (msg.sender != _owner)
            throw;
        _;
    }

    modifier notRented {
        if (_currentRenter != 0x0)
            throw;
        _;
    }

}