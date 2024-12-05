import express, { Express } from 'express'
import { getUserById, getUsers, updateUser } from '../controllers/users'
const router = express.Router()

router.get('/', getUsers)
router.get('/:id', getUserById)
router.put('/:id', updateUser)

export default router
