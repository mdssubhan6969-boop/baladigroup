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
    imageUrl: "https://cdn.mafrservices.com/pim-content/UAE/media/product/2296917/1778004600/2296917_main.jpg?im=Resize=(300,300)",
    name: "Arla Protein Strawberry Yoghurt",
    tagline: "High Protein, Strawberry Flavor, Pack of 3",
    price: 11.49,
    originalPrice: 19.99,
    offerText: "42% OFF",
  },
  {
    imageUrl: "https://cdn.mafrservices.com/pim-content/UAE/media/product/2245139/1756209004/2245139_main.jpg?im=Resize=(300,300)",
    name: "Euro Gourmet Red Cheddar Cheese",
    tagline: "Premium Gourmet Sliced Cheese",
    price: 17.62,
    originalPrice: 23.50,
    offerText: "25% OFF",
  },
  {
    imageUrl: "https://cdn.mafrservices.com/sys-master-root/h0d/h9f/13603365093406/1795216_main.jpg?im=Resize=(300,300)",
    name: "Saha Fresh Chicken Thighs 500g",
    tagline: "Fresh & Halal Chicken Thighs",
    price: 11.79,
    originalPrice: 17.49,
    isCouponPrice: true,
    offerText: "33% OFF",
  },
  {
    imageUrl: "https://cdn.mafrservices.com/pim-content/UAE/media/product/1025554/1762498000/1025554_main.jpg?im=Resize=(300,300)",
    name: "Brazilian Beef Mince Low Fat",
    tagline: "Lean & Premium Brazilian Beef Mince",
    price: 26.50,
    originalPrice: 35.00,
    offerText: "24% OFF",
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
