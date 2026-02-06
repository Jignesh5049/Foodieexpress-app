const express = require('express');
const cors = require('cors');
const { randomUUID } = require('crypto');

const app = express();
const port = 3000;

app.use(
    cors({
        origin: true,
        credentials: true,
    })
);
app.use(express.json());

const users = new Map();

function sanitizeUser(user) {
    return {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone || null,
        birthDate: user.birthDate || null,
    };
}

app.post('/auth/signup', (req, res) => {
    const { name, email, password } = req.body || {};
    if (!name || !email || !password) {
        return res.status(400).json({ message: 'Missing required fields.' });
    }

    if (users.has(email)) {
        return res.status(409).json({ message: 'User already exists.' });
    }

    const user = {
        id: randomUUID(),
        name,
        email,
        password,
    };

    users.set(email, user);
    return res.json({ user: sanitizeUser(user) });
});

app.post('/auth/login', (req, res) => {
    const { email, password } = req.body || {};
    if (!email || !password) {
        return res.status(400).json({ message: 'Missing credentials.' });
    }

    const user = users.get(email);
    if (!user || user.password !== password) {
        return res.status(401).json({ message: 'Invalid credentials.' });
    }

    return res.json({ user: sanitizeUser(user) });
});

app.get('/health', (_req, res) => {
    res.json({ ok: true });
});

app.listen(port, () => {
    // eslint-disable-next-line no-console
    console.log(`Auth server running at http://localhost:${port}`);
});
