// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
import "../@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../@openzeppelin/contracts/math/SafeMath.sol";
import "../@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../@openzeppelin/contracts/utils/Address.sol";
import "../@openzeppelin/contracts/introspection/ERC165.sol";
import "./PetRockFactory.sol";

contract PetRockOwnership is IERC721, ERC165, PetRockFactory {
    using SafeMath for uint256;
    using Address for address;
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    mapping(uint256 => address) private petrockApprovals;
    mapping (address => mapping (address => bool)) private operatorApprovals;

    constructor() {}

    function balanceOf(address owner) external view override returns (uint256 balance) {
        return ownerPetrockCount[owner];
    }

    function ownerOf(uint256 id) external view override returns (address owner) {
        return petrockToOwner[id];
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) private {
        ownerPetrockCount[_to]++;
        ownerPetrockCount[_from]--;
        petrockToOwner[_tokenId] = _to;
        petrockApprovals[_tokenId] = address(0);
        emit Transfer(_from, _to, _tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = this.ownerOf(tokenId);
        return (spender == owner || this.getApproved(tokenId) == spender || this.isApprovedForAll(owner, spender));
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external override {
        require(
            _from != address(0),
            "The from address can't be the zero address"
        );
        require(_to != address(0), "The to address can't be the zero address");
        require(
            petrockToOwner[_tokenId] == _from,
            "The from address doesn't own the token"
        );
        require(
            _from == _msgSender() || petrockApprovals[_tokenId] == _msgSender(),
            "You can't transfer the token, check if you own it or you are approved"
        );
        _transfer(_from, _to, _tokenId);
    }

    function _exists(uint256 _tokenId) public view returns(bool) {
        return (_tokenId < _totalSupply());
    }

    function _totalSupply() public view returns (uint256) {
        return petrocks.length;
    }

    function approve(address _to, uint256 _tokenId) external override {
        require(_exists(_tokenId), "The token doesn't exist");
        require(
            petrockToOwner[_tokenId] == _msgSender() ||
                petrockApprovals[_tokenId] == _msgSender(),
            "You're not allowed to approve this token"
        );
        petrockApprovals[_tokenId] = _to;
        emit Approval(_msgSender(), _to, _tokenId);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(
            _checkOnERC721Received(from, to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _safeTransfer(from, to, tokenId, _data);
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (!to.isContract()) {
            return true;
        }
        bytes memory returndata =
            to.functionCall(
                abi.encodeWithSelector(
                    IERC721Receiver(to).onERC721Received.selector,
                    _msgSender(),
                    from,
                    tokenId,
                    _data
                ),
                "ERC721: transfer to non ERC721Receiver implementer"
            );
        bytes4 retval = abi.decode(returndata, (bytes4));
        return (retval == _ERC721_RECEIVED);
    }

    function getApproved(uint256 _tokenId) external view override returns (address operator) {
        require(_exists(_tokenId));
        return petrockApprovals[_tokenId];
    }

    function setApprovalForAll(address operator, bool _approved) external override {
        require(operator != _msgSender(), "Can't approve yourself");
        operatorApprovals[_msgSender()][operator] = _approved;
        emit ApprovalForAll(_msgSender(), operator, _approved);
    }

    function isApprovedForAll(address owner, address operator) external view override returns (bool) {
        return operatorApprovals[owner][operator];
    }



}
