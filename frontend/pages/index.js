import Head from 'next/head'
import styles from '../styles/Home.module.css'
import { ethers } from "ethers";

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>NFPR</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to Non Fungible Pet Rocks!
        </h1>

        <p className={styles.description}>
          Get started here
        </p>
      </main>
        
      <footer className={styles.footer}>
          a smart contract artwork by donnoh
      </footer>
    </div>
  )
}
