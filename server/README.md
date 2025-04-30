# Dotfiles Showcase Server

This is a Next.js application that showcases the dotfiles repository. It provides a web interface to explore the features and configurations of the dotfiles.

## Getting Started

First, navigate to the `.server` directory:

```bash
cd .server
```

Then, install the dependencies:

```bash
npm install
# or
yarn install
# or
pnpm install
```

Run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Deployment on Vercel

This project is configured for seamless deployment on Vercel. Follow these steps to deploy:

1. **Sign up for Vercel**: If you don't have an account, sign up at [vercel.com](https://vercel.com)

2. **Install Vercel CLI** (optional):
   ```bash
   npm install -g vercel
   ```

3. **Deploy from the `.server` directory**:
   ```bash
   cd .server
   vercel
   ```

   Or deploy directly from the GitHub repository by:
   - Connecting your GitHub account to Vercel
   - Selecting your repository
   - Setting the root directory to `.server`
   - Clicking "Deploy"

4. **Environment Variables** (if needed):
   - Add any required environment variables in the Vercel dashboard
   - For local development, create a `.env.local` file

5. **Custom Domain** (optional):
   - Add a custom domain in the Vercel dashboard
   - Follow the instructions to configure DNS settings

## Features

- Modern UI built with Next.js and Tailwind CSS
- Responsive design that works on all devices
- Showcases the dotfiles configuration
- Links to the GitHub repository
- Automatic deployments via Vercel

## Structure

- `src/app/` - Next.js App Router pages and layouts
- `src/components/` - Reusable React components
- `src/styles/` - Global styles and CSS modules
- `public/` - Static assets like images and fonts

## Technologies Used

- [Next.js](https://nextjs.org/) - React framework
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
- [TypeScript](https://www.typescriptlang.org/) - Type-safe JavaScript
- [Vercel](https://vercel.com/) - Deployment platform
