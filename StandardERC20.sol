import "./AbstractERC20.sol"

/// @title Standard token contract - Standard token interface implementation.
contract PocketinnsToken is Token {

    /*
     *  Token meta data
     */
    string constant public name = "Pocketinns Token";
    string constant public symbol = "Pinns";
    uint8 constant public decimals = 18;
    address public owner;
    address public dutchAuctionAddress;
    
     modifier onlyForDutchAuctionContract() {
        if (msg.sender != dutchAuctionAddress)
            // Only owner is allowed to proceed
            revert();
        _;
    }
    
    
    /*
     *  Data structures
     */
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;

    /*
     *  Public functions
     */
 
    
    function PocketinnsToken(address dutchAuction) public
    {
        owner = msg.sender;
        totalSupply = 150000000 * 10**18;
        balances[dutchAuction] = 30000000 * 10**18;
        balances[owner] = 120000000 * 10**18;
        dutchAuctionAddress = dutchAuction;  // we have stored the dutch auction contract address for burning tokens present after ITO
    }
    
    function burnLeftItoTokens(uint _burnValue)
    public
    onlyForDutchAuctionContract
    {
        totalSupply -=_burnValue;
         balances[dutchAuctionAddress] -= _burnValue;
    }
     
    /// @dev Transfers sender's tokens to a given address. Returns success.
    /// @param _to Address of token receiver.
    /// @param _value Number of tokens to transfer.
    /// @return Returns success of function call.
    function transfer(address _to, uint256 _value)
        public
        returns (bool)
    {
        if (balances[msg.sender] < _value) {
            // Balance too low
            revert();
        }
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
    /// @param _from Address from where tokens are withdrawn.
    /// @param _to Address to where tokens are sent.
    /// @param _value Number of tokens to transfer.
    /// @return Returns success of function call.
    function transferFrom(address _from, address _to, uint256 _value)
        public
        returns (bool)
    {
        if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
            // Balance or allowance too low
            revert();
        }
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    /// @dev Sets approved amount of tokens for spender. Returns success.
    /// @param _spender Address of allowed account.
    /// @param _value Number of approved tokens.
    /// @return Returns success of function call.
    function approve(address _spender, uint256 _value)
        public
        returns (bool)
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /*
     * Read functions
     */
    /// @dev Returns number of allowed tokens for given address.
    /// @param _owner Address of token owner.
    /// @param _spender Address of token spender.
    /// @return Returns remaining allowance for spender.
    function allowance(address _owner, address _spender)
        constant
        public
        returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    /// @dev Returns number of tokens owned by given address.
    /// @param _owner Address of token owner.
    /// @return Returns balance of owner.
    function balanceOf(address _owner)
        constant
        public
        returns (uint256)
    {
        return balances[_owner];
    }
    
    function totalSupply() public constant returns(uint total_Supply)
    {
        return totalSupply;
    }
}

