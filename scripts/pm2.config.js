module.exports = {
  apps: [
    {
      name: "rails-api",
      script: "bundle",
      args: "exec rails s -e production -p 3000",
      interpreter: "none",
      cwd: "./",
      env: {
        RAILS_ENV: "production",
      },
    },
  ],
};
