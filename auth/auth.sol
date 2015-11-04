// @brief Mixin contract to enable standard authorization pattern.
contract DSAuth {
    address _ds_authority;
    function DSAuth() {
        _ds_authority = msg.sender;
    }
    modifier auth() {
        if( _ds_authenticated() ) {
            _
        }
    }
    function _ds_authenticated() internal returns (bool is_authenticated) {
        if( msg.sender == _ds_authority ) {
            return true;
        }
        var A = DSAuthority(_ds_authority);
        return A.can_call( msg.sender, address(this), msg.sig );
    }

    function _ds_get_authority() constant returns (address authority, bool ok) {
        return (_ds_authority, true);
    }
    function _ds_update_authority( address new_authority )
             auth()
             returns (bool success)
    {
        _ds_authority = DSAuthority(new_authority);
        return true;
    }
}

// Use the auth() pattern, but compile the address into code instead
// of into storage. This is useful if you need to use the entire address
// space, for example.
// @brief DSAuth-like mixin contract which puts the authority address
//        into code instead of storage. 
// @dev Optionally implement missing DSAuth functions with your constant address
contract DSStaticAuth {
    function _ds_authenticated( address _ds_authority ) internal returns (bool is_authenticated) {
        if( msg.sender == _ds_authority ) {
            return true;
        }
        var A = DSAuthority(_ds_authority);
        return A.can_call( msg.sender, address(this), msg.sig );
    }
    modifier static_auth( address _ds_authority ) {
        if( _ds_authenticated( _ds_authority ) ) {
            _
        }
    }
    // Implement these with your constant address to make this into a proper DSAuth
    // function _ds_get_authority() constant returns (address authority);
    // function _ds_update_authority( address new_authority ) returns (bool success);
}