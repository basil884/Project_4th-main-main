const MyPatient = require('../../models/MyPatient');

async function create(data) {
  return await MyPatient.create(data);
}

async function getAll() {
  return await MyPatient.find({}).sort({ createdAt: -1 });
}

async function getById(id) {
  const item = await MyPatient.findById(id);
  if (!item) {
    const err = new Error('My patient record not found');
    err.statusCode = 404;
    throw err;
  }
  return item;
}

async function update(id, updates) {
  const item = await MyPatient.findByIdAndUpdate(id, updates, {
    new: true,
    runValidators: true,
  });
  if (!item) {
    const err = new Error('My patient record not found');
    err.statusCode = 404;
    throw err;
  }
  return item;
}

async function remove(id) {
  const item = await MyPatient.findByIdAndDelete(id);
  if (!item) {
    const err = new Error('My patient record not found');
    err.statusCode = 404;
    throw err;
  }
  return item;
}

module.exports = { create, getAll, getById, update, remove };
