const mongoose = require("mongoose");
mongoose.pluralize(null);

var medicineSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    generic: {
        type: String,
        required: true,
    },
    company: {
        type: String,
        required: true,
    },
    strength: {
        type: String,
        required: true,
    },
    price: {
        type: String,
        required: true,
        unique: true,
    },
});

mongoose.model("medicine", medicineSchema);
