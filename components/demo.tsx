"use client";
import React, { useState } from "react";
import { ContainerScroll } from "@/components/ui/container-scroll-animation";
import { TestimonialCard } from "@/components/ui/testimonial-cards";
import { SparklesText } from "@/components/ui/sparkles-text";
import { ProductCard, ProductCardProps } from "@/components/ui/product-card-2";
import Image from "next/image";
import { motion } from "framer-motion";

// 1. Hero Scroll Demo Component
export function HeroScrollDemo() {
  return (
    <div className="flex flex-col overflow-hidden pb-[500px] pt-[1000px]">
      <ContainerScroll
        titleComponent={
          <>
            <h1 className="text-4xl font-semibold text-black dark:text-white">
              Unleash the power of <br />
              <span className="text-4xl md:text-[6rem] font-bold mt-1 leading-none">
                Scroll Animations
              </span>
            </h1>
          </>
        }
      >
        <Image
          src={`https://ui.aceternity.com/_next/image?url=%2Flinear.webp&w=3840&q=75`}
          alt="hero"
          height={720}
          width={1400}
          className="mx-auto rounded-2xl object-cover h-full object-left-top"
          draggable={false}
        />
      </ContainerScroll>
    </div>
  );
}

// 2. Testimonial Shuffle Cards Component
const testimonials = [
  {
    id: 1,
    testimonial: "أفضل سوبرماركت للمنتجات المصرية في عجمان! الملوخية والجبنة القديمة والكشري طازجة وممتازة. كأنك في مصر! \n\nBest Egyptian grocery in Ajman! The fresh koshari ingredients, molokhia, and Egyptian cheese are top-tier. Reminds me of home!",
    author: "طارق المصري (Tarek El-Masry) - Verified Local Guide"
  },
  {
    id: 2,
    testimonial: "خدمة التوصيل السريعة عبر الواتساب ممتازة جداً. المانجو المصري والعيش البلدي طازج وجميل. أنصح به بشدة. \n\nVery fast WhatsApp delivery service and very friendly staff. High quality Egyptian mangoes and fresh Baladi bread! Highly recommended.",
    author: "أميرة حجازي (Amira Hegazi) - Regular Customer"
  },
  {
    id: 3,
    testimonial: "أسعار ممتازة ومكان نظيف جداً. اللحوم الطازجة والبلدي ممتازة. فكرة تحميل الفاتورة والدفع عبر الواتساب مريحة للغاية. \n\nExcellent prices and clean store. The beef cuts are fresh and halal. Downloading the invoice PDF and checking out on WhatsApp is very convenient.",
    author: "يوسف منصور (Youssef Mansour) - Tech Consultant"
  }
];

export function ShuffleCards() {
  const [positions, setPositions] = useState(["front", "middle", "back"]);

  const handleShuffle = () => {
    const newPositions = [...positions];
    newPositions.unshift(newPositions.pop()!);
    setPositions(newPositions);
  };

  return (
    <div className="grid place-content-center overflow-hidden bg-slate-900 px-8 py-24 text-slate-50 min-h-screen h-full w-full">
      <div className="relative -ml-[100px] h-[450px] w-[350px] md:-ml-[175px]">
        {testimonials.map((testimonial, index) => (
          <TestimonialCard
            key={testimonial.id}
            {...testimonial}
            handleShuffle={handleShuffle}
            position={positions[index]}
          />
        ))}
      </div>
    </div>
  );
}

// 3. Sparkles Text Demo Component
export function SparklesTextDemo() {
  return <SparklesText text="BALADI HYPERMARKET" />;
}

// 4. Product Grid Demo Component
const products: ProductCardProps[] = [
  {
    imageUrl: "https://image01.realme.net/general/20250109/1736415319795d54ca63564df4a429066610426dbb975.png.webp?width=1440&height=1440&size=376999",
    name: "realme Buds Wireless 5 ANC",
    tagline: "Best ANC, Beast Battery Life",
    price: 1399,
    originalPrice: 2799,
    offerText: "1400 Off",
  },
  {
    imageUrl: "https://image01.realme.net/general/20250317/17422067439182f5867123e114ce09d2ef0306d1a8f9b.png.webp?width=1440&height=1440&size=1025011",
    name: "realme Buds Air7",
    tagline: "52dB Segment's Strongest ANC*",
    price: 2699,
    originalPrice: 4899,
    isCouponPrice: true,
    offerText: "Up to 100 Coupon",
  },
  {
    imageUrl: "https://image01.realme.net/general/20250519/1747633988406ef120377e0d14fc68f95246e96625de1.png.webp?width=1440&height=1440&size=813046",
    name: "realme Buds Air7 Pro",
    tagline: "The Sound Of Ai",
    price: 4499,
    originalPrice: 8999,
    offerText: "Up to 500 Bank Offer",
  },
  {
    imageUrl: "https://image01.realme.net/general/20241014/17288795936668c68fced6fb04cdb9365c8915f7fbd77.png.webp?width=1440&height=1440&size=282698",
    name: "realme Techlife Studio H1",
    tagline: "Style Your Sound",
    price: 3999,
    originalPrice: 7999,
    offerText: "Up to 500 Bank Offer",
  },
];

const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
    },
  },
};

const itemVariants = {
  hidden: { y: 20, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
    transition: {
      type: "spring",
      stiffness: 100,
      damping: 10,
    },
  },
};

export default function ProductGridDemo() {
  return (
    <div className="w-full bg-background px-4 py-16">
      <div className="mx-auto max-w-7xl">
        <div className="mb-12 text-center">
          <h2 className="text-4xl font-bold tracking-tight" style={{ color: '#F5A623' }}>
            Let's Groove
          </h2>
        </div>

        <motion.div
          className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4"
          variants={containerVariants}
          initial="hidden"
          animate="visible"
        >
          {products.map((product, index) => (
            <motion.div key={index} variants={itemVariants}>
              <ProductCard 
                {...product} 
                onAddToCart={() => alert(`${product.name} added to cart!`)}
              />
            </motion.div>
          ))}
        </motion.div>
      </div>
    </div>
  );
}
