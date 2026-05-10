const cartAPI = require('../services/api/cartAPI');

// @desc    Add item to cart
// @route   POST /api/cart
// @access  Public/Private
const createCartItem = async (req, res) => {
    try {
        const cartItem = await cartAPI.createCartItem(req.body);
        res.status(201).json({ success: true, data: cartItem });
    } catch (error) {
        res.status(error.statusCode || 400).json({ success: false, error: error.message });
    }
};

// @desc    Get all cart items
// @route   GET /api/cart
// @access  Public
const getCartItems = async (req, res) => {
    try {
        const cartItems = await cartAPI.getCartItems();
        res.status(200).json({ success: true, count: cartItems.length, data: cartItems });
    } catch (error) {
        res.status(error.statusCode || 500).json({ success: false, error: error.message });
    }
};

// @desc    Get single cart item
// @route   GET /api/cart/:id
// @access  Public
const getCartItemById = async (req, res) => {
    try {
        const cartItem = await cartAPI.getCartItemById(req.params.id);
        res.status(200).json({ success: true, data: cartItem });
    } catch (error) {
        res.status(error.statusCode || 500).json({ success: false, error: error.message });
    }
};

// @desc    Update a cart item
// @route   PUT /api/cart/:id
// @access  Public/Private
const updateCartItem = async (req, res) => {
    try {
        const cartItem = await cartAPI.updateCartItem(req.params.id, req.body);
        res.status(200).json({ success: true, data: cartItem });
    } catch (error) {
        res.status(error.statusCode || 400).json({ success: false, error: error.message });
    }
};

// @desc    Delete a cart item
// @route   DELETE /api/cart/:id
// @access  Public/Private
const deleteCartItem = async (req, res) => {
    try {
        await cartAPI.deleteCartItem(req.params.id);
        res.status(200).json({ success: true, data: {} });
    } catch (error) {
        res.status(error.statusCode || 500).json({ success: false, error: error.message });
    }
};

module.exports = {
    createCartItem,
    getCartItems,
    getCartItemById,
    updateCartItem,
    deleteCartItem
};
